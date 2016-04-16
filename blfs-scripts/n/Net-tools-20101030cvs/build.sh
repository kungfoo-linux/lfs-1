#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=net-tools-CVS_20101030.tar.gz
srcdir=net-tools-CVS_20101030
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/net-tools-CVS_20101030-remove_dups-1.patch

yes "" | make config
make
make DESTDIR=$BUILDDIR update

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: the basic tools for setting up networking
 This package includes the important tools for controlling the network
 subsystem of the Linux kernel.  This includes arp, ifconfig, netstat, rarp,
 nameif and route.  Additionally, this package contains utilities relating to
 particular network hardware types (plipconfig, slattach, mii-tool) and
 advanced aspects of IP configuration (iptunnel, ipmaddr).
 .
 [arp]
 is used to manipulate the kernel's ARP cache, usually to add or delete an
 entry, or to dump the entire cache.
 .
 [ipmaddr]
 adds, deletes and shows an interface's multicast addresses.
 .
 [iptunnel]
 adds, changes, deletes and shows an interface's tunnels.
 .
 [mii-tool]
 checks or sets the status of a network interface's Media Independent
 Interface (MII) unit.
 .
 [nameif]
 names network interfaces based on MAC addresses.
 .
 [netstat]
 is used to report network connections, routing tables, and interface
 statistics.
 .
 [plipconfig]
 is used to fine tune the PLIP device parameters, to improve its performance.
 .
 [rarp]
 is used to manipulate the kernel's RARP table.
 .
 [route]
 is used to manipulate the IP routing table.
 .
 [slattach]
 attaches a network interface to a serial line. This allows you to use normal
 terminal lines for point-to-point links to other computers.
EOF
}

build
