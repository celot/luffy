SVN_VERSION=`svnversion . |  sed -n 's/.*:\([0-9]*\).*/\1/p'`
if [ -z "$SVN_VERSION" ]; then
SVN_VERSION=`svnversion . |  sed -n 's/\([0-9]*\).*/\1/p'`
fi

IS_CPRN_KLW=`cat .config | grep CONFIG_CPRN_KLW=y | wc -l`
IS_CPRW_KLW=`cat .config | grep CONFIG_CPRW_KLW=y | wc -l`
IS_CPRN_NLW=`cat .config | grep CONFIG_CPRN_NLW=y | wc -l`
IS_CPRW_NLW=`cat .config | grep CONFIG_CPRW_NLW=y | wc -l`
IS_CPRN_NLW2=`cat .config | grep CONFIG_CPRN_NLW2=y | wc -l`
IS_CPRW_NLW2=`cat .config | grep CONFIG_CPRW_NLW2=y | wc -l`

if [ "$IS_CPRN_KLW" = "1" ]; then
    MODEL_TYPE="CPRNKLW"
    MODULE="KYM11"
elif [ "$IS_CPRW_KLW" = "1" ]; then
    MODEL_TYPE="CPRWKLW"
    MODULE="KYM11"
elif [ "$IS_CPRN_NLW" = "1" ]; then
    MODEL_TYPE="CPRNNLW"
    MODULE="PM-L300ND"
elif [ "$IS_CPRW_NLW" = "1" ]; then
    MODEL_TYPE="CPRWNLW"
    MODULE="PM-L300ND"
elif [ "$IS_CPRN_NLW2" = "1" ]; then
    MODEL_TYPE="CPRNNLW2"
    MODULE="SIM7100"
elif [ "$IS_CPRW_NLW2" = "1" ]; then
    MODEL_TYPE="CPRWNLW2"
    MODULE="SIM7100"
else
    echo "============================================="
    echo "MODEL TYPE : UNKNOWN"
    echo "============================================="
    exit 0;
fi

IS_REMOTE_SYSLOG=`cat .config | grep CONFIG_USE_REMOTE_SYSLOG=y | wc -l`
if [ "$IS_REMOTE_SYSLOG" = "1" ]; then
APPEND_NAME=_SYSLOG
fi

FLASH_SIZE="16M"
CARRIER_NAME="HTC"
IMAGE_NAME=uImage3_${MODEL_TYPE}_${FLASH_SIZE}_${SVN_VERSION}_${CARRIER_NAME}
LN_IMAGE_NAME=uImage3_${MODEL_TYPE}_${FLASH_SIZE}_${CARRIER_NAME}${APPEND_NAME}

echo "============================================="
echo "MODEL TYPE : ${MODEL_TYPE}"       
echo "Module Name: ${MODULE}"       
echo "Flash Size : ${FLASH_SIZE}"
echo "Image Name : ${LN_IMAGE_NAME}"
cp $1 $2/${IMAGE_NAME}
rm -rf $2/${LN_IMAGE_NAME}
ln -s $2/${IMAGE_NAME} $2/${LN_IMAGE_NAME}
if [ "$3" = "release" ]; then
curl -T $2/${IMAGE_NAME} ftp://192.168.10.240/Uploads/ --user tftp:1234567890
fi
echo "SVN_VERSION: $SVN_VERSION"
echo "CARRIER_NAME: HITACHI"
echo "============================================="

