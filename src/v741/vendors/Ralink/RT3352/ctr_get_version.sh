#! /bin/sh

echo "#include <stdio.h>" > ./getVersion.c
echo "#include \"../../../autoconf.h\"" >> ./getVersion.c
echo "#include \"../../../ctr_version.h\""  >> ./getVersion.c

echo "int main(void){ printf(\"%s,%s\",CTR_MODEL_NAME,CTR_VERSION_NAME); return 0; }" >> ./getVersion.c

gcc -o ./getVersion ./getVersion.c
FIRM_VER=`./getVersion`;
echo $FIRM_VER

