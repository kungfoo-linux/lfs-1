#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cups-1.7.5-source.tar.bz2
srcdir=cups-1.7.5
#tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

## If you need to access a remote Cups print server, use the following patch:
#patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/cups-1.7.5-content_type-1.patch
#
#patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/cups-1.7.5-blfs-1.patch
#aclocal -I config-scripts
#autoconf -I config-scripts
#
#CC=gcc \
#./configure --libdir=/usr/lib \
#	--with-rcdir=/tmp/cupsinit \
#	--with-docdir=/usr/share/cups/doc \
#	--with-system-groups=lpadmin \
#	--enable-libpaper \
#	--disable-gnutls \
#	--enable-openssl
#make
make DSTROOT=$BUILDDIR install

rm -rf $BUILDDIR/tmp
mkdir $BUILDDIR/usr/share/doc
ln -svfn ../cups/doc $BUILDDIR/usr/share/doc/cups-1.7.5

# Create a basic Cups client configuration file:
echo "ServerName /var/run/cups/cups.sock" > $BUILDDIR/etc/cups/client.conf

# Remove filters that are now part of the Cups Filters package:
rm -rf $BUILDDIR/usr/share/cups/banners
rm -rf $BUILDDIR/usr/share/cups/data/testprint

cleanup_src .. $srcdir
}

configure() {
# To automatically start the Cups print service when the system is rebooted:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-cups
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Colord (>= 1.2.3), DBus (>= 1.8.8), libusb (>= 1.0.19), \
Avahi (>= 0.6.31), OpenSSL (>= 1.0.1i), libpaper (>= 1.1.24), \
Linux-PAM (>= 1.1.8), OpenJDK (>= 1.7.0.65), Python2 (>= 2.7.8), \
xdg-utils (>= 1.1.0rc2)
Description: Common UNIX Printing System
 The Common Unix Printing System (CUPS) is a print spooler and associated
 utilities. It is based on the "Internet Printing Protocol" and provides
 printing services to most PostScript and raster printers.
 .
 Kernel configuration:
 .
 NOTE: There used to be a conflict between the Cups libusb backend and the
 usblp kernel driver. This is no longer the case and cups will work with both
 of these enabled.
 . To support USB printer:
 --------------------------------------------------
 . Device Drivers  --->
 .   [*] USB support  --->
 .       <*> OHCI HCD (USB 1.1) support: Y or M
 .       <*> UHCI HCD (most Intel and VIA) support: Y or M
 .       <*> USB Printer support: Y or M
 --------------------------------------------------
 .
 . TO support parallel printer
 --------------------------------------------------
 . Device Drivers  --->
 .   <*> Parallel port support  --->
 .       <*> PC-style hardware: Y or M
 .
 .       Character devices  --->
 .       <*> Parallel printer support: Y or M
 --------------------------------------------------
 .
 NOTE:
 runtime dependency: cups-filters (>= 1.0.58)
 .
 [accept]
 instructs the printing system to accept print jobs to the specified
 destinations.
 .
 [cancel]
 cancels existing print jobs from the print queues.
 .
 [cupsaddsmb]
 exports printers to the Samba software for use with Windows clients.
 .
 [cups-config]
 is a Cups program configuration utility.
 .
 [cupsctl]
 updates or queries the cupsd.conf file for a server.
 .
 [cupsd]
 is the scheduler for the Common Unix Printing System.
 .
 [cupsfilter]
 is a front-end to the Cups filter subsystem which allows you to convert a
 file to a specific format.
 .
 [cupstestdsc]
 tests the conformance of PostScript files.
 .
 [cupstestppd]
 tests the conformance of PPD files.
 .
 [ippfind]
 finds internet printing protocol printers.
 .
 [ipptool]
 sends IPP requests to the specified URI and tests and/or displays the
 results.
 .
 [lp]
 submits files for printing or alters a pending job.
 .
 [lpadmin]
 configures printer and class queues provided by Cups.
 .
 [lpc]
 provides limited control over printer and class queues provided by Cups.
 .
 [lpinfo]
 lists the available devices or drivers known to the Cups server.
 .
 [lpmove]
 moves the specified job to a new destination.
 .
 [lpoptions]
 displays or sets printer options and defaults.
 .
 [lppasswd]
 adds, changes or deletes passwords in the Cups digest password file
 passwd.md5.
 .
 [lpq]
 shows the current print queue status on the named printer.
 .
 [lpr]
 submits files for printing.
 .
 [lprm]
 cancels print jobs that have been queued for printing.
 .
 [lpstat]
 displays status information about the current classes, jobs, and printers.
 .
 [ppdc]
 compiles PPDC source files into one or more PPD files.
 .
 [ppdhtml]
 reads a driver information file and produces a HTML summary page that lists
 all of the drivers in a file and the supported options.
 .
 [ppdi]
 imports one or more PPD files into a PPD compiler source file.
 .
 [ppdmerge]
 merges two or more PPD files into a single, multi-language PPD file.
 .
 [ppdpo]
 extracts UI strings from PPDC source files and updates either a GNU gettext
 or Mac OS X strings format message catalog source file for translation.
 .
 [reject]
 instructs the printing system to reject print jobs to the specified
 destinations.
 .
 [libcups.so]
 contains the Cups API functions.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent passwd "lp" > /dev/null 2>&1 ; then
            useradd -c "Print Service User" -d /var/spool/cups -g lp \
		-s /bin/false -u 9 lp
	fi
	if ! getent group "lpadmin" > /dev/null 2>&1 ; then
	    groupadd -g 19 lpadmin
	    gpasswd -a $USER lpadmin
	fi
	
	echo "[NOTE] runtime dependency: cups-filters (>= 1.0.58)"
	'
}

build
