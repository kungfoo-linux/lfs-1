#!/bin/bash -e

# verify user ID
if [ $USER != "lfs" ]; then
    echo "need lfs user to build temporary system."
    exit 1
fi

echo "start to build temporary system ..."
pushd . > /dev/null
scripts=`find . -maxdepth 1 -name '[0-9][0-9]-*.sh' | sort`

for script in $scripts; do
    NAME=`readlink -f $script`
    LOG=${NAME%.sh}.log

    ( ./$script 2>&1 | tee $LOG && exit $PIPESTATUS )
done
popd > /dev/null
echo "... build temporary system success"
