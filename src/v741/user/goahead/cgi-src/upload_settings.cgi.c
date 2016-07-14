
/*
 * Codes at here are heavily taken from upload.cgi.c which is for large file uploading , but
 * in fact "upload_settings" only need few memory(~16k) so it is not necessary to follow
 * upload.cgi.c at all.
 *
 * YYHuang@Ralink TODO: code size.
 *
 */

#include <unistd.h>	//for unlink
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <linux/reboot.h>
#include <linux/autoconf.h>

#define RFC_ERROR "RFC1867 ...."

#define REFRESH_TIMEOUT		"60000"		/* 40000 = 40 secs*/

void *memmem(const void *buf, size_t buf_len, const void *byte_line, size_t byte_line_len)
{
	unsigned char *bl = (unsigned char *)byte_line;
	unsigned char *bf = (unsigned char *)buf;
	unsigned char *p  = bf;

	while(byte_line_len <= (buf_len - (p - bf))) {
		unsigned int b = *bl & 0xff;
		if((p = (unsigned char *) memchr(p, b, buf_len - (p - bf))) != NULL) {
			if((memcmp(p, byte_line, byte_line_len)) == 0)
				return p;
			else
				p++;
		} else {
			break;
		}
	}
	return NULL;
}

#define MEM_SIZE	1024
#define MEM_HALT	512
int findStrInFile(char *filename, int offset, unsigned char *str, int str_len)
{
	int pos = 0, rc;
	FILE *fp;
	unsigned char mem[MEM_SIZE];

	if(str_len > MEM_HALT)
		return -1;
	if(offset < 0)
		return -1;

	fp = fopen(filename, "rb");
	if(!fp)
		return -1;

	rewind(fp);
	fseek(fp, offset + pos, SEEK_SET);
	rc = fread(mem, 1, MEM_SIZE, fp);
	while(rc) {
		unsigned char *mem_offset;
		mem_offset = (unsigned char*)memmem(mem, rc, str, str_len);
		if(mem_offset) {
			fclose(fp);	//found it
			return (mem_offset - mem) + pos + offset;
		}

		if(rc == MEM_SIZE) {
			pos += MEM_HALT;	// 8
		} else
			break;

		rewind(fp);
		fseek(fp, offset + pos, SEEK_SET);
		rc = fread(mem, 1, MEM_SIZE, fp);
	}

	fclose(fp);
	return -1;
}

/*
 *  ps. callee must free memory...
 */
void *getMemInFile(char *filename, int offset, int len)
{
	void *result;
	FILE *fp;
	if((fp = fopen(filename, "r")) == NULL) {
		return NULL;
	}
	fseek(fp, offset, SEEK_SET);
	result = malloc(sizeof(unsigned char) * len);
	if(!result)
		return NULL;
	if(fread(result, 1, len, fp) != len) {
		free(result);
		return NULL;
	}
	return result;
}

void import(char *filename, int offset, int len)
{
	char cmd[4096];
	char data;
	FILE *fp, *src;
	char *pname = tempnam("/var", "set");

	snprintf(cmd, 4096, "cp %s /var/tmpcgi", filename);
	system(cmd);

	if(!(fp = fopen(pname, "w+"))) {
		return;
	}

	if(!(src = fopen(filename, "r"))) {
		fclose(fp);
		return;
	}

	if(fseek(src, offset, SEEK_SET) == -1) {
		printf("fseek error\n");
	}

	// ralink_init utility need this to identity(?) .dat file.
	//fprintf(fp, "Default\n");

	while(len > 0) {
		if(! fread(&data, 1, 1, src))
			break;
		fwrite(&data, 1, 1, fp);
		len--;
	}

	fclose(fp);
	fclose(src);

	system("ralink_init clear 2860");
	//snprintf(cmd, 4096, "ralink_init renew 2860 %s", pname);
	snprintf(cmd, 4096, "ralink_init import 2860 %s", pname);
	system(cmd);
	unlink(pname);
}

int main(int argc, char *argv[])
{
	int file_begin, file_end;
	int line_begin, line_end;
	char *boundary = 0; int boundary_len;
	char *filename = getenv("UPLOAD_FILENAME");
	char errMsg[1024] = {0,};

	if(!filename) {
		sprintf(errMsg,"failed, can't get env var.\n");
		goto err;
	}

	line_begin = 0;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg,"%s", RFC_ERROR);
		goto err;
	}
	boundary_len = line_end - line_begin;
	boundary = getMemInFile(filename, line_begin, boundary_len);

	// sth like this..
	// Content-Disposition: form-data; name="filename"; filename="\\192.168.3.171\tftpboot\a.out"
	//
	char *line, *semicolon, *user_filename;
	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}
	line = getMemInFile(filename, line_begin, line_end - line_begin);
	if(strncasecmp(line, "content-disposition: form-data;", strlen("content-disposition: form-data;"))) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}
	semicolon = line + strlen("content-disposition: form-data;") + 1;
	if(!(semicolon = strchr(semicolon, ';'))) {
		sprintf(errMsg, "dont support multi-field upload.\n");
		goto err;
	}
	user_filename = semicolon + 2;
	if(strncasecmp(user_filename, "filename=", strlen("filename="))) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}
	user_filename += strlen("filename=");
	//until now we dont care about what  true filename is.
	free(line);

	// We may check a string  "Content-Type: application/octet-stream" here
	// but if our firmware extension name is the same with other known name,
	// the browser will define other content-type itself instead,
	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}

	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}

	file_begin = line_end + 2;

	if((file_end = findStrInFile(filename, file_begin, boundary, boundary_len)) == -1) {
		sprintf(errMsg, "%s", RFC_ERROR);
		goto err;
	}
	file_end -= 2;		// back 2 chars.(\r\n);

	#define FMT_LINE "#The following line must not be removed."
	if( findStrInFile(filename, line_begin, FMT_LINE, strlen(FMT_LINE)) == -1) 
	{
		sprintf(errMsg, "%s", "File Format Mismatch..");
		goto err;
	}

	system("/usr/sbin/module fslog EV \"Router reboot request(Import)\""); //tyranno151022 
	
	import(filename, file_begin, file_end - file_begin);
	printf("Server: %s\nPragma: no-cache\nContent-type: text/html\n\n", getenv("SERVER_SOFTWARE"));
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=settings.asp\"></head>\n");
	printf("<body></body></html>\n");
	fflush(stdout);

	system("sleep 3 && reboot &");
	if(boundary) free(boundary);
	return;

err:
	printf("Server: %s\nPragma: no-cache\nContent-type: text/html\n\n", getenv("SERVER_SOFTWARE"));
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=settings.asp&result=%s\"></head>\n",errMsg);
	printf("<body></body></html>\n");
	fflush(stdout);
	if(boundary) free(boundary);
	exit(0);
}
