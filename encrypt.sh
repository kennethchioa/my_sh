#!/bin/sh
FROM_DIR=$1
SECRETPASSWORD=$2
TO_FILENAME=$3
encrypt()
{  
if [ $# -eq 3 ]
then
    tar -zcvf - ${FROM_DIR} | openssl des3 -salt -k ${SECRETPASSWORD} | dd of=${TO_FILENAME}.des3
else 
    echo "Wrong Parameters!"	
fi
}
encrypt ${FROM_DIR} ${SECRETPASSWORD} ${TO_FILENAME}
