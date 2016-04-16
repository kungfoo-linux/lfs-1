#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=01-linux/opencv-3.0.0.zip
srcdir=opencv-3.0.0
unzip $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir release && cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr ..
make $JOBS
make DESTDIR=$BUILDDIR install
cd ..

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+2 (>= 2.24.24), FFmpeg (>= 2.3.3)
Description: Open Source Computer Vision Library.
 OpenCV is released under a BSD license and hence it’s free for both academic
 and commercial use. It has C++, C, Python and Java interfaces and supports
 Windows, Linux, Mac OS, iOS and Android. OpenCV was designed for computational
 efficiency and with a strong focus on real-time applications. Written in
 optimized C/C++, the library can take advantage of multi-core processing.
 Enabled with OpenCL, it can take advantage of the hardware acceleration of the
 underlying heterogeneous compute platform. Adopted all around the world,
 OpenCV has more than 47 thousand people of user community and estimated number
 of downloads exceeding 9 million. Usage ranges from interactive art, to mines
 inspection, stitching maps on the web or through advanced robotics.
EOF
}

build
