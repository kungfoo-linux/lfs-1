#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=Python-3.4.1.tar.xz
srcdir=Python-3.4.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

CXX="/usr/bin/g++" \
./configure --prefix=/usr \
	--enable-shared \
	--with-system-expat \
	--with-system-ffi \
	--without-ensurepip
make
make DESTDIR=$BUILDDIR install

chmod -v 755 $BUILDDIR/usr/lib/libpython3.4m.so
chmod -v 755 $BUILDDIR/usr/lib/libpython3.so

install -v -dm755 $BUILDDIR/usr/share/doc/python-3.4.1/html &&
tar --strip-components=1 \
	--no-same-owner \
	--no-same-permissions \
	-C $BUILDDIR/usr/share/doc/python-3.4.1/html \
	-xvf $BLFSSRC/$PKGLETTER/$CURDIR/python-3.4.1-docs-html.tar.bz2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libffi (>= 3.1), openssl (>= 1.0.1i), sqlite (>= 3.8.6)
Suggests: BlueZ-5.23, Berkeley_DB-6.1.19, Tk-8.6.2
Description: interactive high-level object-oriented language
 Python is an interpreted, interactive object-oriented programming language 
 suitable (amongst other uses) for distributed application development, 
 scripting, numeric computing and system testing.
 .
 [idle3]
 is a wrapper script that opens a Python aware GUI editor. For this script to
 run, you must have installed Tk before Python so that the Tkinter Python
 module is built.
 .
 [pydoc3]
 is the Python documentation tool.
 .
 [python3]
 is an interpreted, interactive, object-oriented programming language.
 .
 [python3.4]
 is a version-specific name for the python program.
 .
 [pyvenv]
 creates virtual Python environments in one or more target directories.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF="
	# In order for python3 to find the installed documentation, you must
	# add the following environment variable to individual user's or the
	# system's profile:
	if ! env | grep \"PYTHONDOCS\" > /dev/null 2>&1 ; then
	    echo \"export PYTHONDOCS=/usr/share/doc/python-3.4.1/html\" >> \
		    /etc/profile
	fi
	"
}

build
