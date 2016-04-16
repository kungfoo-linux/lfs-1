#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=liblinear-1.94.tar.gz
srcdir=liblinear-1.94
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make lib

mkdir -pv $BUILDDIR/usr/{include,lib}
install -vm644 linear.h $BUILDDIR/usr/include
install -vm755 liblinear.so.1 $BUILDDIR/usr/lib
ln -sfv liblinear.so.1 $BUILDDIR/usr/lib/liblinear.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for large linear classification
 This package provides a library for learning linear classifiers for large
 scale applications. It supports Support Vector Machines (SVM) with L2 and L1
 loss, logistic regression, multi class classification and also Linear
 Programming Machines (L1-regularized SVMs). Its computational complexity
 scales linearly with the number of training examples making it one of the
 fastest SVM solvers around.
 .
 [liblinear.so]
 is a large linear classification library.
EOF
}

build
