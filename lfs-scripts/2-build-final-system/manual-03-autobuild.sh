#!/bin/bash -e

# verify user ID
if [ $UID != 0 ]; then
    echo "need root user to build final system."
    exit 1
fi

echo "start to build final system ..."
pushd . > /dev/null
scripts=`find . -maxdepth 1 -name '[0-9][0-9]-*.sh' | sort`

for script in $scripts; do
    NAME=`readlink -f $script`
    LOG=${NAME%.sh}.log

    #echo $script
    ( ./$script 2>&1 | tee $LOG && exit $PIPESTATUS )
done
popd > /dev/null
echo "... build final system success"
