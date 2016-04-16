#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wireshark-1.12.1.tar.bz2
srcdir=wireshark-1.12.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# Optionally, fix the description of the program in the title. The first
# change overwrites the default "SVN Unknown" in the title and the second
# overwrites a utility script that resets the version to "unknown":
cat > svnversion.h << "EOF"
#define SVNVERSION "BLFS"
#define SVNPATH "source"
EOF

cat > make-version.pl << "EOF"
#!/usr/bin/perl
EOF

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-gtk3=yes \
	--with-qt=no
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/wireshark-1.12.1
install -v -m755 -d $BUILDDIR/usr/share/pixmaps/wireshark
install -v -m644 README{,.linux} doc/README.* doc/*.{pod,txt} \
	$BUILDDIR/usr/share/doc/wireshark-1.12.1

pushd $BUILDDIR/usr/share/doc/wireshark-1.12.1
    for FILENAME in ../../wireshark/*.html; do
        ln -s -v -f $FILENAME .
    done
popd

install -v -m644 -D wireshark.desktop \
	$BUILDDIR/usr/share/applications/wireshark.desktop
install -v -m644 -D image/wsicon48.png \
	$BUILDDIR/usr/share/pixmaps/wireshark.png
install -v -m644    image/*.{png,ico,xpm,bmp} \
	$BUILDDIR/usr/share/pixmaps/wireshark

# set ownership and permissions of sensitive applications to only allow
# authorized users:
gid=62
chown -v root:$gid $BUILDDIR/usr/bin/{tshark,dumpcap}

sed -i 's/\(^dofile(DATA_DIR.."console.lua")\)/--\1/' \
	$BUILDDIR/usr/share/wireshark/init.lua

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), GTK+3 (>= 3.12.2), libpcap (>= 1.6.2), \
GnuTLS (>= 3.3.7), libgcrypt (>= 1.6.2), Lua (>= 5.2.3), \
OpenSSL (>= 1.0.1i), PortAudio (>= 19.20140130)
Description: network traffic analyzer
 The Wireshark package contains a network protocol analyzer, also known as a
 “sniffer”. This is useful for analyzing data captured “off the wire” from a
 live network connection, or data read from a capture file. Wireshark provides
 both a graphical and a TTY-mode front-end for examining captured network
 packets from over 500 protocols, as well as the capability to read capture
 files from many other popular network analyzers.
 .
 Kernel configuration:
 --------------------------------------------------
 . Networking support  --->
 .     Networking options  --->
 .       <*> Packet: sockets monitoring interface
 --------------------------------------------------
 .
 NOTE:
 If you want an unpriviledged user to execute wireshark, run the following
 command as the root user:
     usermod -a -G wireshark <username>
 .
 [capinfos]
 reads a saved capture file and returns any or all of several statistics about
 that file. It is able to detect and read any capture supported by the
 Wireshark package.
 .
 [captype]
 prints the file types of capture files.
 .
 [dftest]
 is a display-filter-compiler test program.
 .
 [dumpcap]
 is a network traffic dump tool. It lets you capture packet data from a live
 network and write the packets to a file.
 .
 [editcap]
 edits and/or translates the format of capture files. It knows how to read
 libpcap capture files, including those of tcpdump, Wireshark and other tools
 that write captures in that format.
 .
 [mergecap]
 combines multiple saved capture files into a single output file.
 .
 [randpkt]
 creates random-packet capture files.
 .
 [rawshark]
 dump and analyze raw libpcap data.
 .
 [reordercap]
 reorder timestamps of input file frames into output file.
 .
 [text2pcap]
 reads in an ASCII hex dump and writes the data described into a libpcap-style
 capture file.
 .
 [tshark]
 is a TTY-mode network protocol analyzer. It lets you capture packet data from
 a live network or read packets from a previously saved capture file.
 .
 [wireshark]
 is the GTK+ GUI network protocol analyzer. It lets you interactively browse
 packet data from a live network or from a previously saved capture file.
 .
 [wireshark-qt]
 is the Qt GUI network protocol analyzer. It lets you interactively browse
 packet data from a live network or from a previously saved capture file.
 .
 [libwireshark.so]
 contains functions used by the Wireshark programs to perform filtering and
 packet capturing.
 .
 [libwiretap.so]
 is a library being developed as a future replacement for libpcap, the current
 standard Unix library for packet capturing. For more information, see the
 README file in the source wiretap directory.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	if ! getent group "wireshark" > /dev/null 2>&1 ; then
	    groupadd -g 62 wireshark
	fi

	echo -e \
"If you want an unpriviledged user to execute wireshark, run the following \
command as the root user:
usermod -a -G wireshark <username>"
	'

POSTRM_CONF_DEF='
	if getent group "wireshark" > /dev/null 2>&1 ; then
	    groupdel wireshark
	fi
	'
}

build
