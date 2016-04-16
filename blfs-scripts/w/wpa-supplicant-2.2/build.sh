#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wpa_supplicant-2.2.tar.gz
srcdir=wpa_supplicant-2.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/wpa_supplicant

cat > .config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
#CONFIG_CTRL_IFACE_DBUS=y
#CONFIG_CTRL_IFACE_DBUS_NEW=y
#CONFIG_CTRL_IFACE_DBUS_INTRO=y
EOF

make BINDIR=/sbin LIBDIR=/lib

# If you have installed Qt-4.8.6 and wish to build the WPA Supplicant GUI
# program, run the following commands:
pushd wpa_gui-qt4
qmake wpa_gui.pro
make
popd

mkdir -pv $BUILDDIR/{sbin,usr/share/man/man{5,8}}
install -v -m755 wpa_{cli,passphrase,supplicant} $BUILDDIR/sbin/
install -v -m644 doc/docbook/wpa_supplicant.conf.5 \
	$BUILDDIR/usr/share/man/man5/
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 \
	$BUILDDIR/usr/share/man/man8/

#mkdir -pv $BUILDDIR/usr/share/dbus-1/system-services
#install -v -m644 dbus/fi.{epitest.hostap.WPASupplicant,w1.wpa_supplicant1}.service \
#	$BUILDDIR/usr/share/dbus-1/system-services/
#
#mkdir -pv $BUILDDIR/etc/dbus-1/system.d
#install -v -m644 dbus/dbus-wpa_supplicant.conf \
#	$BUILDDIR/etc/dbus-1/system.d/wpa_supplicant.conf

mkdir -pv $BUILDDIR/usr/{bin,share/{man/man8,applications,pixmaps}}
install -v -m755 wpa_gui-qt4/wpa_gui $BUILDDIR/usr/bin/
install -v -m644 doc/docbook/wpa_gui.8 $BUILDDIR/usr/share/man/man8/
install -v -m644 wpa_gui-qt4/wpa_gui.desktop $BUILDDIR/usr/share/applications/
install -v -m644 wpa_gui-qt4/icons/wpa_gui.svg $BUILDDIR/usr/share/pixmaps/

cleanup_src ../.. $srcdir
}

configure() {
# you need to install the /lib/services/wpa script included in
# blfs-bootscripts-20140919 package:
pushd $BLFSSRC/b/bootscripts
make DESTDIR=$BUILDDIR install-service-wpa
popd

mkdir -pv $BUILDDIR/etc/sysconfig
$BUILDDIR/sbin/wpa_passphrase SSID SECRET_PASSWORD > \
	$BUILDDIR/etc/sysconfig/wpa_supplicant-wifi0.conf
cat > $BUILDDIR/etc/sysconfig/ifconfig.wifi0 << "EOF"
ONBOOT="yes"
IFACE="wlan0"
SERVICE="wpa"

# Additional arguments to wpa_supplicant
WPA_ARGS=""

WPA_SERVICE="dhcpcd"
DHCP_START="-b -q"
DHCP_STOP="-k"
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libnl (>= 3.2.25), OpenSSL (>= 1.0.1i)
Recommends: dhcpcd (>= 6.4.3), DBus (>= 1.8.8), libxml2 (>= 2.9.1)
Suggests: Qt4 (>= 4.8.6)
Description: WPA supplicant implementation
 WPA Supplicant is a Wi-Fi Protected Access (WPA) client and IEEE 802.1X
 supplicant. It implements WPA key negotiation with a WPA Authenticator and
 Extensible Authentication Protocol (EAP) authentication with an
 Authentication Server. In addition, it controls the roaming and IEEE 802.11
 authentication/association of the wireless LAN driver. This is useful for
 connecting to a password protected wireless access point.
 .
 Kernel configuration:
 ---------------------------------------------------------------------------
 [*] Networking support --->                   [CONFIG_NET]
     Wireless  --->
        cfg80211 - wireless configuration API: Y or M
            cfg80211 wireless extensions compatibility: Y
        Generic IEEE 802.11 Networking Stack (mac80211): Y or M
 [*] Device Drivers  --->
     Network device support  --->
        Wireless LAN  --->
        Select the appropriate drivers for your hardware.
 ---------------------------------------------------------------------------
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='update-desktop-database'
}

build
