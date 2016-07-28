#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=Python-2.7.8.tar.xz
srcdir=Python-2.7.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-shared \
	--with-system-expat \
	--with-system-ffi \
	--enable-unicode=ucs4
make
make DESTDIR=$BUILDDIR install
chmod -v 755 $BUILDDIR/usr/lib/libpython2.7.so.1.0

# Since Python 2 is in maintenance mode, and Python 3 is recommended by 
# upstream for development, you probably do not need to install the 
# documentation.
# However, if you still want to install documentation for both Python
# versions, be sure to define the PYTHONDOCS variable for the version
# you want to use, each time you need to consult the documentation. 
install -v -dm755 $BUILDDIR/usr/share/doc/python-2.7.8 &&
tar --strip-components=1 -C $BUILDDIR/usr/share/doc/python-2.7.8 \
	--no-same-owner -xvf \
	$BLFSSRC/$PKGLETTER/$CURDIR/python-2.7.8-docs-html.tar.bz2 &&
find $BUILDDIR/usr/share/doc/python-2.7.8 -type d -exec chmod 0755 {} \; &&
find $BUILDDIR/usr/share/doc/python-2.7.8 -type f -exec chmod 0644 {} \;

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
EOF
}

set_deb_def() {
POSTINST_CONF_DEF="
	# In order for python to find the installed documentation, you must 
	# add the following environment variable to individual user's or 
	# the system's profile:
	if ! env | grep \"PYTHONDOCS\" > /dev/null 2>&1 ; then
	    echo \"export PYTHONDOCS=/usr/share/doc/python-2.7.8\" >> /etc/profile
	fi
	"
}

build
