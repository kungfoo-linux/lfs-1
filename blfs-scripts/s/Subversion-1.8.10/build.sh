#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=subversion-1.8.10.tar.bz2
srcdir=subversion-1.8.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--with-apache-libexecdir
make

# If you have a multi core CPU and normally run make with multiple jobs (eg
# make -j4) then a bug in the Makefile will prevent the Perl bindings
# compiling correctly. Fix the Makefile with: 
sed -i 's#Makefile.PL.in$#& libsvn_swig_perl#' Makefile.in

make DESTDIR=$BUILDDIR -j1 install
install -v -m755 -d $BUILDDIR/usr/share/doc/subversion-1.8.10
cp -v -R doc/* $BUILDDIR/usr/share/doc/subversion-1.8.10

cleanup_src .. $srcdir
}

configure() {
# The following instructions will install a Subversion server, which will be
# set up to use OpenSSH as the secure remote access method, with svnserve
# available for anonymous access.

# Additionally you should set umask 002 while working with a repository so
# that all new files will be writable by owner and group. This is made
# mandatory by creating a wrapper script for svn and svnserve:

mv $BUILDDIR/usr/bin/svn $BUILDDIR/usr/bin/svn.orig
mv $BUILDDIR/usr/bin/svnserve $BUILDDIR/usr/bin/svnserve.orig

cat > $BUILDDIR/usr/bin/svn << "EOF"
#!/bin/sh

umask 002
/usr/bin/svn.orig "$@"
EOF
	
cat > $BUILDDIR/usr/bin/svnserve << "EOF"
#!/bin/sh

umask 002
/usr/bin/svnserve.orig "$@"
EOF
chmod 0755 $BUILDDIR/usr/bin/svn{,serve}

# configure subversion:
mkdir -pv $BUILDDIR/usr/sbin
cat > $BUILDDIR/usr/sbin/svndiff << "EOF"
#!/bin/sh

DIFF="vimdiff"
LEFT=${6}
RIGHT=${7}
$DIFF -o $LEFT $RIGHT
EOF
chmod +x $BUILDDIR/usr/sbin/svndiff

# sed -i '/^# editor-cmd = / c editor-cmd = vi' ~/.subversion/config
# sed -i '/^# diff-cmd = / c diff-cmd = \/usr\/sbin\/svndiff' \
#	~/.subversion/config

# If you want to disable auto store auth and password info, set the 
# following options in ~/.subversion/config:
# sed -i -e 's/^# password-stores =$/password-stores =/' \
#	-e 's/^# store-passwords = no$/store-passwords = no/' \
#	-e 's/^# store-auth-creds = no$/store-auth-creds = no/' \
#	~/.subversion/config
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Apr-Util (>= 1.5.3), SQLite (>= 3.8.6), OpenSSL (>= 1.0.1i), \
Serf (>= 1.3.7), Apache (>= 2.4.10), OpenSSH (>= 6.6p1)
Description: advanced version control system
 Subversion is a version control system that is designed to be a compelling
 replacement for CVS in the open source community. It extends and enhances
 CVS' feature set, while maintaining a similar interface for those already
 familiar with CVS.
 .
 To start the server at boot time, install the svn bootscript included in the
 blfs-bootscripts-20140919 package:
     make install-svn
 .
 Start subversion manually:
     svnserve -d -r <your SVN repository root directory>
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "svn" > /dev/null 2>&1 ; then
	    groupadd -g 56 svn
	fi

	if ! getent passwd "svn" > /dev/null 2>&1 ; then
	    useradd -c "SVN Owner" -d /home/svn -m -g svn \
	        -s /bin/false -u 56 svn
	fi
	'

POSTRM_CONF_DEF='
	if getent passwd "svn" > /dev/null 2>&1 ; then
	    userdel svn
	fi

	if getent group "svn" > /dev/null 2>&1 ; then
	    groupdel svn
	fi
	'
}

build
