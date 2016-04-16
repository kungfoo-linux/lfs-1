#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=bluez-5.23.tar.xz
srcdir=bluez-5.23
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you are going to use BlueZ with gnome-bluetooth and/or kde bluedevil,
# apply the following patch:
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/bluez-5.23-obexd_without_systemd-1.patch

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--enable-library \
	--disable-systemd
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/sbin
ln -svf ../libexec/bluetooth/bluetoothd $BUILDDIR/usr/sbin

install -v -dm755 $BUILDDIR/etc/bluetooth
install -v -m644 src/main.conf $BUILDDIR/etc/bluetooth/main.conf

install -v -dm755 $BUILDDIR/usr/share/doc/bluez-5.23
install -v -m644 doc/*.txt $BUILDDIR/usr/share/doc/bluez-5.23

cleanup_src .. $srcdir
}

configure() {
# /etc/bluetooth/main.conf is installed automatically during the install.
# Additionally, there are three supplementary configuration files.
# /etc/sysconfig/bluetooth is installed as a part of the boot script below. In
# addition, you optionally can install the following, as the root user:

cat > $BUILDDIR/etc/bluetooth/rfcomm.conf << "EOF"
# rfcomm.conf
# Set up the RFCOMM configuration of the Bluetooth subsystem in the Linux kernel.
# Use one line per command
# See the rfcomm man page for options


# End of rfcomm.conf
EOF

cat > $BUILDDIR/etc/bluetooth/uart.conf << "EOF"
#uart.conf
# Attach serial devices via UART HCI to BlueZ stack
# Use one line per device
# See the hciattach man page for options

# End of uart.conf
EOF

# To automatically start the bluetoothd daemon when the system is rebooted,
# install the /etc/rc.d/init.d/bluetooth bootscript from the
# blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-bluetooth
popd
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: DBus (>= 1.8.8), GLib (>= 2.40.0), libical (>= 1.0)
Description: Bluetooth protocol stack for Linux
 .
 Kernel configuration:
 ---------------------------------------------------------------------------
 [*] Networking support --->                   [CONFIG_NET]
   <*> or <M> Bluetooth subsystem support ---> [CONFIG_BT]
     <*> or <M> RFCOMM protocol support        [CONFIG_BT_RFCOMM]
     [*] RFCOMM TTY support                    [CONFIG_BT_RFCOMM_TTY]
     <*> or <M> BNEP protocol support          [CONFIG_BT_BNEP]
     [*] Multicast filter support              [CONFIG_BT_BNEP_MC_FILTER]
     [*] Protocol filter support               [CONFIG_BT_BNEP_PROTO_FILTER]
     <*> or <M> HIDP protocol support          [CONFIG_BT_HIDP]
     Bluetooth device drivers --->
   <*> or <M> RF switch subsystem support
   Select the appropriate drivers for your Bluetooth hardware.
 ---------------------------------------------------------------------------
 .
 [bccmd]
 is used to issue BlueCore commands to Cambridge Silicon Radio devices.
 .
 [bluetoothd]
 is the Bluetooth daemon.
 .
 [ciptool]
 is used to set up, maintain, and inspect the CIP configuration of the
 Bluetooth subsystem in the Linux kernel.
 .
 [hciattach]
 is used to attach a serial UART to the Bluetooth stack as HCI transport
 interface.
 .
 [hciconfig]
 is used to configure Bluetooth devices.
 .
 [hcitool]
 is used to configure Bluetooth connections and send some special command to
 Bluetooth devices.
 .
 [hid2hci]
 is used to set up switch supported Bluetooth devices into the HCI mode and
 back.
 .
 [l2ping]
 is used to send a L2CAP echo request to the Bluetooth MAC address given in
 dotted hex notation.
 .
 [rctest]
 is used to test RFCOMM communications on the Bluetooth stack.
 .
 [rfcomm]
 is used to set up, maintain, and inspect the RFCOMM configuration of the
 Bluetooth subsystem in the Linux kernel.
 .
 [sdptool]
 is used to perform SDP queries on Bluetooth devices.
 .
 [libbluetooth.so]
 contains the BlueZ 4 API functions.
EOF
}

build
