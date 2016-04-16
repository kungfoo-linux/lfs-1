#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=firefox-32.0.1.source.tar.bz2
srcdir=mozilla-release
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

cp ../mozconfig .

# There is a problem on i686 systems when building Firefox with gcc versions
# ranging from 4.8 to 4.9.1 and using the switch “--enable-optimize”. There
# are two alternatives. The best one is to upgrade gcc to version 4.9.2 or
# later because it will give better perfomance and smaller binaries. However,
# if you do not wish to upgrade gcc, reduce the level of optimization with: 
test $(uname -m) = "i686" && sed -i 's/enable-optimize/&=-O2/' mozconfig || true

make -f client.mk
make -f client.mk DESTDIR=$BUILDDIR INSTALL_SDK= install
mkdir -pv $BUILDDIR/usr/lib/mozilla/plugins
ln -sfv ../mozilla/plugins $BUILDDIR/usr/lib/firefox-32.0.1

cleanup_src .. $srcdir
}

configure() {
# If you use a desktop environment like Gnome or KDE you may like to create a
# firefox.desktop file so that Firefox appears in the panel's menus. If you
# didn't enable startup-notification in your mozconfig change the
# StartupNotify line to false:
mkdir -pv $BUILDDIR/usr/share/{applications,pixmaps}

cat > $BUILDDIR/usr/share/applications/firefox.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Exec=firefox %u
Terminal=false
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

ln -sfv /usr/lib/firefox-32.0.1/browser/icons/mozicon128.png \
	$BUILDDIR/usr/share/pixmaps/firefox.png
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), GTK+2 (>= 2.24.24), Zip (>= 3.0), \
UnZip (>= 6.0), ICU (>= 53.1), libevent (>= 2.0.21), libvpx (>= 1.3.0), \
NSPR (>= 4.10.7), NSS (>= 3.17), SQLite (>= 3.8.6), yasm (>= 1.3.0), \
cURL (>= 7.37.1), dbus-glib (>= 0.102), gst-plugins-base1 (>= 1.4.1), \
gst-plugins-good1 (>= 1.4.1), gst-libav1 (>= 1.4.1), libnotify (>= 0.7.6), \
OpenJDK (>= 1.6), PulseAudio (>= 5.0), startup-notification (>= 0.12), \
Wget (>= 1.15), Wireless-tools (>= 29)
Description: Mozilla Firefox Web browser
EOF
}

build
