#include "upload.cgi.h"
#include <linux/autoconf.h>
#include <sys/types.h>
#include <stdlib.h>

#include "../../../autoconf.h"

#include "../../../ctr_version.h"


#define REFRESH_TIMEOUT		"40000"		/* 40000 = 40 secs*/

#define RFC_ERROR "RFC1867 error"

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



#if defined (UPLOAD_FIRMWARE_SUPPORT)

/*
 *  taken from "mkimage -l" with few modified....
 */

int isSameModel(char *ptr)
{
	char buf[64] = {0,};
	char szFirmVersion[32] = {0,};
	char* nl = NULL;

	FILE *nvfp = NULL;
	if( (nvfp = popen("nvram_get 2860 ignoreFwModel", "r")) == NULL )
		goto fw_check;


	if(!fgets(buf, sizeof(buf), nvfp)){
		pclose(nvfp);
		goto fw_check;
	}

	pclose(nvfp);
	if(nl = strchr(buf, '\n'))
		*nl = '\0';

	//fprintf(stderr, "%d, %s\r\n", strlen(buf), buf);
	if(strlen(buf) != 0 && *buf == '1')
		return 0;
	



fw_check:
	//fprintf(stderr, "%s\r\n", "fw_check");

	memcpy(szFirmVersion, ptr+32, 32);
	szFirmVersion[31] = 0;

	if(strncmp(szFirmVersion, CTR_MODEL_NAME, strlen(CTR_MODEL_NAME)) != 0)
		return -1;			

	return 0;
}


int check(char *imagefile, int offset, int len, char *err_msg)
{
	struct stat sbuf;

	int  data_len;
	char *data;
	unsigned char *ptr;
	unsigned long checksum;

	image_header_t header;
	image_header_t *hdr = &header;

	int ifd;

	if((unsigned)len < sizeof(image_header_t)) {
		sprintf(err_msg, "Bad size: \"%s\" is no valid image\n", imagefile);
		return 0;
	}

	ifd = open(imagefile, O_RDONLY);
	if(!ifd) {
		sprintf(err_msg, "Can't open %s: %s\n", imagefile, strerror(errno));
		return 0;
	}

	if(fstat(ifd, &sbuf) < 0) {
		close(ifd);
		sprintf(err_msg, "Can't stat %s: %s\n", imagefile, strerror(errno));
		return 0;
	}

	ptr = (unsigned char *) mmap(0, sbuf.st_size, PROT_READ, MAP_SHARED, ifd, 0);

	if((caddr_t)ptr == (caddr_t) - 1) {
		close(ifd);
		sprintf(err_msg, "Can't mmap %s: %s\n", imagefile, strerror(errno));
		return 0;
	}
	ptr += offset;

	/*
	 *  handle Header CRC32
	 */
	memcpy(hdr, ptr, sizeof(image_header_t));

	if(ntohl(hdr->ih_magic) != IH_MAGIC) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "Bad Magic Number: \"%s\" is no valid image\n", imagefile);
		return 0;
	}

	data = (char *)hdr;

	checksum = ntohl(hdr->ih_hcrc);
	hdr->ih_hcrc = htonl(0);	/* clear for re-calculation */

	if(crc32(0, data, sizeof(image_header_t)) != checksum) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: \"%s\" has bad header checksum!\n", imagefile);
		return 0;
	}

	/*
	 *  handle Data CRC32
	 */
	data = (char *)(ptr + sizeof(image_header_t));
	data_len  = len - sizeof(image_header_t) ;

	if(crc32(0, data, data_len) != ntohl(hdr->ih_dcrc)) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: \"%s\" has corrupted data!\n", imagefile);
		return 0;
	}

#if 1
	/*
	 * compare MTD partition size and image size
	 */
#if defined (CONFIG_RT2880_ROOTFS_IN_RAM)
	if(len > getMTDPartSize("\"Kernel\"")) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: the image file(0x%x) is bigger than Kernel MTD partition.\n", len);
		return 0;
	}
#elif defined (CONFIG_RT2880_ROOTFS_IN_FLASH)
#ifdef CONFIG_ROOTFS_IN_FLASH_NO_PADDING
	if(len > getMTDPartSize("\"Kernel_RootFS\"")) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: the image file(0x%x) is bigger than Kernel_RootFS MTD partition.\n", len);
		return 0;
	}
#else
	if(len < CONFIG_MTD_KERNEL_PART_SIZ) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: the image file(0x%x) size doesn't make sense.\n", len);
		return 0;
	}

	if((len - CONFIG_MTD_KERNEL_PART_SIZ) > getMTDPartSize("\"RootFS\"")) {
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "*** Warning: the image file(0x%x) is bigger than RootFS MTD partition.\n", len - CONFIG_MTD_KERNEL_PART_SIZ);
		return 0;
	}
#endif
#else
#error "goahead: no CONFIG_RT2880_ROOTFS defined!"
#endif
#endif


	// MODEL CHECK ----------------------------------------------------------------------->>
	if(isSameModel(ptr) < 0)
	{
		munmap(ptr, len);
		close(ifd);
		sprintf(err_msg, "Unmached firmware : %s\n", CTR_MODEL_NAME);
		return 0;			
	}
	
	// MODEL CHECK <<-----------------------------------------------------------------------



	munmap(ptr, len);
	close(ifd);

	return 1;
}

#endif /* UPLOAD_FIRMWARE_SUPPORT */


#if defined (UPLOAD_FIRMWARE_SUPPORT) || defined(UPLOAD_SYSTEM_SUPPORT)
int proc_upload_firmware(char *filename, int offset, int len, char* dev)
{
	int status;
	char cmd[512];	
#if 1
	if(filename == NULL || len <= 0) return -1;
	
	snprintf(cmd, sizeof(cmd), "/usr/sbin/upgrader -o %d -l %d -w %s -i %s &", offset, len, filename, dev);
	status = system(cmd);
	if(!WIFEXITED(status) || WEXITSTATUS(status) != 0)
	{
		return 0;
	}
#else
	pid_t  pid;

	if(filename == 0 || len <= 0) return -1;
	if((pid = fork()) < 0)
	{
		return 0;
	}
	else if(pid != 0)
	{
		return 1;
	}
	setsid();

	if(!strcmp(dev, "System")) // 4Mb
	{
		snprintf(cmd, sizeof(cmd), "/bin/mtd_write erase %s", dev);
		status = system(cmd);
	}

#ifdef CONFIG_CELOT_MTD_16M
#if 0
#if  0//bill140414
	if(!strcmp(dev, "Kernel")) 
	{
		snprintf(cmd, sizeof(cmd), "/usr/sbin/upgrader -o %d -l %d -w %s", offset, len, filename);
	}
	else
#else
	system("/usr/sbin/upgrader -b 0");
#endif //0
#endif
	{
		snprintf(cmd, sizeof(cmd), "/bin/mtd_write -o %d -l %d write %s %s", offset, len, filename, dev);
	}
#else
	snprintf(cmd, sizeof(cmd), "/bin/mtd_write -o %d -l %d write %s %s", offset, len, filename, dev);
#endif	
	status = system(cmd);
	unlink(filename);


	if(!WIFEXITED(status) || WEXITSTATUS(status) != 0)
	{
		return 0;
	}
	if(len < 1024 * 200)
	{
		sleep(3);
	}

	system("reboot &");
#endif
	return 1;
}
#endif

int main(int argc, char *argv[])
{
	int file_begin, file_end;
	int line_begin, line_end;
	char err_msg[256];
	char *boundary = 0; int boundary_len;
	char *filename = getenv("UPLOAD_FILENAME");
	char errMsg[1024] = {0,};
	int upload_ok= 0;

	line_begin = 0;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 1);
		goto err;
	}
	boundary_len = line_end - line_begin;
	boundary = getMemInFile(filename, line_begin, boundary_len);
	//printf("boundary:%s\n", boundary);

	// sth like this..
	// Content-Disposition: form-data; name="filename"; filename="\\192.168.3.171\tftpboot\a.out"
	//
	char *line, *semicolon, *user_filename;
	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 2);
		goto err;
	}
	line = getMemInFile(filename, line_begin, line_end - line_begin);
	if(strncasecmp(line, "content-disposition: form-data;", strlen("content-disposition: form-data;"))) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 3);
		goto err;
	}
	semicolon = line + strlen("content-disposition: form-data;") + 1;
	if(!(semicolon = strchr(semicolon, ';'))) {
		sprintf(errMsg, "We dont support multi-field upload.\n");
		goto err;
	}
	user_filename = semicolon + 2;
	if(strncasecmp(user_filename, "filename=", strlen("filename="))) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 4);
		goto err;
	}
	user_filename += strlen("filename=");
	//until now we dont care about what the true filename is.
	free(line);

	// We may check a string  "Content-Type: application/octet-stream" here,
	// but if our firmware extension name is the same with other known ones,
	// the browser would use other content-type instead.
	// So we dont check Content-type here...
	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 5);
		goto err;
	}

	line_begin = line_end + 2;
	if((line_end = findStrInFile(filename, line_begin, "\r\n", 2)) == -1) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 6);
		goto err;
	}

	file_begin = line_end + 2;

	if((file_end = findStrInFile(filename, file_begin, boundary, boundary_len)) == -1) {
		sprintf(errMsg, "%s %d", RFC_ERROR, 7);
		goto err;
	}
	file_end -= 2;		// back 2 chars.(\r\n);
	//printf("file:%s, file_begin:%d, len:%d<br>\n", filename, file_begin, file_end - file_begin);

	// examination
#if defined (UPLOAD_FIRMWARE_SUPPORT)
	if(!check(filename, file_begin, file_end - file_begin, err_msg)) {
		if(strncmp(err_msg, "Unmached firmware", strlen("Unmached firmware")) == 0)
			sprintf(errMsg, "%s", "Unmached model name");
		else
			sprintf(errMsg, "%s", "Not a valid firmware");
		goto err;
	}

	/*
	 * write the current linux version into flash.
	 */
	write_flash_kernel_version(filename, file_begin);
#ifdef CONFIG_RT2880_DRAM_8M
	system("killall daemon");
	system("killall goahead");
#endif

	// flash write
	upload_ok = proc_upload_firmware(filename, file_begin, file_end - file_begin, "Kernel");
#elif defined (UPLOAD_BOOTLOADER_SUPPORT)
	mtd_write_bootloader(filename, file_begin, file_end - file_begin);
	upload_ok = 1;
#elif defined (UPLOAD_SYSTEM_SUPPORT)
	upload_ok =  proc_upload_firmware(filename, file_begin, file_end - file_begin, "System");
#else
#error "no upload support defined!"
#endif
	if(upload_ok!=1)
	{
		sprintf(errMsg, "%s", "Error file size");
		goto err;
	}

	printf("Server: %s\nPragma: no-cache\nContent-type: text/html\n\n", getenv("SERVER_SOFTWARE"));
#if defined (UPLOAD_FIRMWARE_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&wait=90\"></head>\n");
#elif defined (UPLOAD_BOOTLOADER_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&wait=65\"></head>\n");
#elif defined (UPLOAD_SYSTEM_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&wait=65\"></head>\n");
#endif
	printf("<body></body></html>\n");
	fflush(stdout);

	if(boundary) free(boundary);
#if defined (UPLOAD_BOOTLOADER_SUPPORT) || defined (CONFIG_RT2880_DRAM_8M)
	system("sleep 3 && reboot &");
#endif	
	exit(0);

err:
	printf("Server: %s\nPragma: no-cache\nContent-type: text/html\n\n", getenv("SERVER_SOFTWARE"));
#if defined (UPLOAD_FIRMWARE_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&result=%s\"></head>\n",errMsg);
#elif defined (UPLOAD_BOOTLOADER_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&result=%s\"></head>\n",errMsg);
#elif defined (UPLOAD_SYSTEM_SUPPORT)
	printf("<html><head><meta http-equiv=\"refresh\" content=\"0;URL=/menu/saved.asp?retPage=upload_firmware.asp&result=%s\"></head>\n",errMsg);
#endif
	printf("<body></body></html>\n");
	fflush(stdout);
	if(boundary)  free(boundary);
	unlink(filename);
	exit(-1);
}

