#!/bin/sh

# 0 : 10M Half
# 1 : 10M Full
# 2 : 100M Half
# 3 : 100M Full
# 4 : Auto
wanComSpeed=`nvram_get 2860 wanComSpeed`
lanComSpeed=`nvram_get 2860 lanComSpeed`

if [ "$wanComSpeed" = "" ]; then $wanComSpeed=4; fi
if [ "$lanComSpeed" = "" ]; then $lanComSpeed=4; fi

# 10base/half     : "0"
# 10base/full      : "100"        
# 100base/half   : "2000"
# 100base/full    : "2100"
# autoreg            : "3100"
portRegValue1=3100
portRegValue2=3100

if [ $wanComSpeed = 0 ]; then
    portRegValue1=0
    p1Value=1010
elif [ $wanComSpeed = 1 ]; then
    portRegValue1=100
    p1Value=1110
elif [ $wanComSpeed = 2 ]; then
    portRegValue1=2000
    p1Value=1011
elif [ $wanComSpeed = 3 ]; then
    portRegValue1=2100
    p1Value=1111
else
    portRegValue1=3100
    p1Value=0000
fi

if [ $lanComSpeed = 0 ]; then
    portRegValue2=0
    p2Value=0000
elif [ $lanComSpeed = 1 ]; then
    portRegValue2=100
    p2Value=0200
elif [ $lanComSpeed = 2 ]; then
    portRegValue2=2000
    p2Value=0002
elif [ $lanComSpeed = 3 ]; then
    portRegValue2=2100
    p2Value=0202
else
    portRegValue2=3100
    p2Value=0000
fi

p1Value1=`expr substr $p1Value 1 1`
p1Value2=`expr substr $p1Value 2 1`
p1Value3=`expr substr $p1Value 3 1`
p1Value4=`expr substr $p1Value 4 1`
p2Value1=`expr substr $p2Value 1 1`
p2Value2=`expr substr $p2Value 2 1`
p2Value3=`expr substr $p2Value 3 1`
p2Value4=`expr substr $p2Value 4 1`

dex_to_hex()
{
    lVal=0
    if [ $1 = 10 ];then
        lVal=a
    elif [ $1 = 11 ]; then
        lVal=b
    elif [ $1 = 12 ]; then
        lVal=c
    elif [ $1 = 13 ]; then
        lVal=d
    elif [ $1 = 14 ]; then
        lVal=e
    elif [ $1 = 15 ]; then
        lVal=f
    else
        lVal=$1
    fi

    echo $lVal
    return
}

pValue1=`expr $p1Value1 + $p2Value1`
pValue2=`expr $p1Value2 + $p2Value2`
pValue3=`expr $p1Value3 + $p2Value3`
pValue4=`expr $p1Value4 + $p2Value4`

if [ $p1Value != 0000 ]; then
    pValue4=`expr $pValue4 + 12`
fi
#pValue2=`expr $pValue2 + 12`
if [ $p1Value = 1110 -o $p1Value = 1111 ]; then
    pValue2=`expr $pValue2 + 12`
fi
#pValue4=`expr $pValue4 + 12`

pValue1=`dex_to_hex $pValue1`
pValue2=`dex_to_hex $pValue2`
pValue3=`dex_to_hex $pValue3`
pValue4=`dex_to_hex $pValue4`

###########################################
pForceValuePrefix=001f

if [ $wanComSpeed = 4 -a $lanComSpeed = 4  ]; then
    pForceValuePrefix=0000
elif  [ $wanComSpeed = 4 -a $lanComSpeed != 4  ]; then
    pForceValuePrefix=0002
elif  [ $wanComSpeed != 4 -a $lanComSpeed = 4  ]; then
    pForceValuePrefix=001d
else
    pForceValuePrefix=001f
fi
###########################################

pValue=$pForceValuePrefix$pValue1$pValue2$pValue3$pValue4

echo "wanComSpeed:$wanComSpeed"
echo "lanComSpeed:$lanComSpeed"
echo "p1Value:$p1Value"
echo "p2Value:$p2Value"
echo "portRegValue1:$portRegValue1"
echo "portRegValue2:$portRegValue2"
echo "pForceValuePrefix:$pForceValuePrefix"
echo "pValue:$pValue"

reg s b0110000
reg w 84 $pValue
mii_mgr -s -p 0 -r 0 -v $portRegValue1
mii_mgr -s -p 1 -r 0 -v $portRegValue2

