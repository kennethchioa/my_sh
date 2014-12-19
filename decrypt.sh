#!/bin/sh
FROM_FILENAME=$1
SECRETPASSWORD=$2
dencrypt()
{  
if [ $# -eq 2 ]
then
	dd if=${FROM_FILENAME}.des3 |openssl des3 -d -k ${SECRETPASSWORD}|tar zxf -
else 
    echo "Wrong Parameters!"	
fi
}
dencrypt ${FROM_FILENAME} ${SECRETPASSWORD}
