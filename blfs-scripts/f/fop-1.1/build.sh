#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fop-1.1-src.tar.gz
srcdir=fop-1.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# Ensure $JAVA_HOME is set correctly before beginning the build. To build the
# JIMI SDK and/or XMLUnit extension classes, ensure the corresponding .jar
# files can be found via the CLASSPATH environment variable. 

case `uname -m` in
  i?86)
    jai_tarball=jai-1_1_3-lib-linux-i586.tar.gz
    jre_libdir=i386
    ;;

  x86_64)
    jai_tarball=jai-1_1_3-lib-linux-amd64.tar.gz
    jre_libdir=amd64
    ;;
esac
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$jai_tarball
mkdir -pv $BUILDDIR/$JAVA_HOME/jre/lib/{ext,$jre_libdir}
cp -v jai-1_1_3/lib/{jai*,mlibwrapper_jai.jar} $BUILDDIR/$JAVA_HOME/jre/lib/ext
cp -v jai-1_1_3/lib/libmlib_jai.so $BUILDDIR/$JAVA_HOME/jre/lib/$jre_libdir

cp -v jai-1_1_3/lib/{jai*,mlibwrapper_jai.jar} $JAVA_HOME/jre/lib/ext
cp -v jai-1_1_3/lib/libmlib_jai.so $JAVA_HOME/jre/lib/$jre_libdir

ant compile
ant jar-main
ant javadocs
mv build/javadocs .

install -v -d -m755                                     $BUILDDIR/opt/fop-1.1
cp -v  KEYS LICENSE NOTICE README                       $BUILDDIR/opt/fop-1.1
cp -va build conf examples fop* javadocs lib status.xml $BUILDDIR/opt/fop-1.1

# The documents expend many disk space (73M), if you not use it often,
# delete it:
rm -rf $BUILDDIR/opt/fop-1.1/javadocs/

cleanup_src .. $srcdir
}

configure() {
ln -svf fop-1.1 $BUILDDIR/opt/fop

# fop.sh 
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/fop.sh << "EOF"
# Begin /etc/profile.d/fop.sh

# Set FOP_HOME directory
FOP_HOME=/opt/fop

PATH=$PATH:$FOP_HOME

#FOP_OPTS="-Xmx<RAM_Installed>m"

export FOP_HOME

# End /etc/profile.d/fop.sh
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: apache-ant (>= 1.9.4)
Description: XML formatter driven by XSL Formatting Objects (XSL-FO)
 The FOP (Formatting Objects Processor) package contains a print formatter
 driven by XSL formatting objects (XSL-FO). It is a Java application that
 reads a formatting object tree and renders the resulting pages to a specified
 output. Output formats currently supported include PDF, PCL, PostScript, SVG,
 XML (area tree representation), print, AWT, MIF and ASCII text. The primary
 output target is PDF.
 .
 [fop]
 is a wrapper script to the java command which sets up the fop environment and
 passes the required parameters.
 .
 [fop.jar]
 contains all the fop Java classes.
EOF
}

build
