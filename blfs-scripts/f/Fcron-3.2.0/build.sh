#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fcron-3.2.0.src.tar.gz
srcdir=fcron-3.2.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

if ! getent group "fcron" > /dev/null 2>&1 ; then
	groupadd -g 22 fcron
fi

if ! getent passwd "fcron" > /dev/null 2>&1 ; then
	useradd -d /dev/null -c "Fcron User" -g fcron \
		-s /bin/false -u 22 fcron
fi

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--without-sendmail \
	--with-boot-install=no \
	--with-systemdsystemunitdir=no \
	--with-pam=no
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
# To automatically start fcron daemon when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-fcron
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: process scheduling daemon
 The cron daemon is a background process that runs particular programs at
 particular times (for example, every minute, day, week, or month), as
 specified in a crontab. By default, users may also create crontabs of their
 own so that processes are run on their behalf.
 .
 Output from the commands is usually mailed to the system administrator (or to
 the user in question); you should probably install a mail system as well so
 that you can receive these messages.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "fcron" > /dev/null 2>&1 ; then
	    groupadd -g 22 fcron
	fi

	if ! getent passwd "fcron" > /dev/null 2>&1 ; then
	    useradd -d /dev/null -c "Fcron User" -g fcron \
	        -s /bin/false -u 22 fcron
	fi
	
	pattern="^\s*cron"
	file=/etc/syslog.conf
	line="cron.* -/var/log/cron.log"
	addline_unique "$pattern" "$line" $file
	/etc/rc.d/init.d/sysklogd reload
	'

POSTRM_CONF_DEF='
	if getent passwd "fcron" > /dev/null 2>&1 ; then
	    userdel fcron
	fi

	if getent group "fcron" > /dev/null 2>&1 ; then
	    groupdel fcron
	fi
	
	pattern="^\s*cron"
	file=/etc/syslog.conf
	delline "$pattern" $file
	'
}

build
