#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=qt-everywhere-opensource-src-4.8.6.tar.gz
srcdir=qt-everywhere-opensource-src-4.8.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

export QT4DIR=/opt/qt-4.8.6

sed -i -e "/#if/d" -e "/#error/d" -e "/#endif/d" \
     config.tests/unix/libmng/libmng.cpp &&

sed -i '/CONFIG -/ a\isEmpty(OUTPUT_DIR): OUTPUT_DIR = ../..' \
     src/3rdparty/webkit/Source/WebKit2/DerivedSources.pro &&

./configure -prefix $QT4DIR      \
            -sysconfdir /etc/xdg \
            -confirm-license     \
            -opensource          \
            -release             \
            -dbus-linked         \
            -openssl-linked      \
            -system-sqlite       \
            -plugin-sql-sqlite   \
            -no-phonon           \
            -no-phonon-backend   \
            -no-nis              \
            -no-openvg           \
            -nomake demos        \
            -nomake examples     \
            -optimized-qmake
make
make INSTALL_ROOT=$BUILDDIR install

ln -svfn $QT4DIR $BUILDDIR/opt/qt4

for file in `basename -a -s .prl $BUILDDIR/$QT4DIR/lib/lib*.prl`; do
    sed -r -e '/^QMAKE_PRL_BUILD_DIR/d' \
        -e 's/(QMAKE_PRL_LIBS =).*/\1/' \
	-i $BUILDDIR/$QT4DIR/lib/${file}.prl
    perl -pi -e "s, -L$PWD/?\S+,,g" $BUILDDIR/$QT4DIR/lib/pkgconfig/${file##lib}.pc
done
unset file

install -v -Dm644 src/gui/dialogs/images/qtlogo-64.png \
	$BUILDDIR/usr/share/pixmaps/qt4logo.png
install -v -Dm644 tools/assistant/tools/assistant/images/assistant-128.png \
	$BUILDDIR/usr/share/pixmaps/assistant-qt4.png
install -v -Dm644 tools/designer/src/designer/images/designer.png \
	$BUILDDIR/usr/share/pixmaps/designer-qt4.png
install -v -Dm644 tools/linguist/linguist/images/icons/linguist-128-32.png \
	$BUILDDIR/usr/share/pixmaps/linguist-qt4.png
install -v -Dm644 tools/qdbus/qdbusviewer/images/qdbusviewer-128.png \
	$BUILDDIR/usr/share/pixmaps/qdbusviewer-qt4.png

# splite doc to an alone package Qt4-doc-4.8.6
rm -rf $BUILDDIR/$QT4DIR/{demos,doc,examples,tests}

cleanup_src .. $srcdir
}

configure() {
export QT4LINK=/opt/qt4
install -dm755 $BUILDDIR/etc/profile.d
install -dm755 $BUILDDIR/usr/share/applications

cat > $BUILDDIR/etc/profile.d/qt4.sh << EOF
export QT4DIR=/opt/qt4
export PATH=$PATH:/opt/qt4/bin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/qt4/lib/pkgconfig
EOF

cat > $BUILDDIR/usr/share/applications/assistant-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Assistant 
Comment=Shows Qt4 documentation and examples
Exec=$QT4LINK/bin/assistant
Icon=assistant-qt4.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF

cat > $BUILDDIR/usr/share/applications/designer-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Designer
Comment=Design GUIs for Qt4 applications
Exec=$QT4LINK/bin/designer
Icon=designer-qt4.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat > $BUILDDIR/usr/share/applications/linguist-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Linguist 
Comment=Add translations to Qt4 applications
Exec=$QT4LINK/bin/linguist
Icon=linguist-qt4.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat > $BUILDDIR/usr/share/applications/qdbusviewer-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 QDbusViewer 
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT4LINK/bin/qdbusviewer
Icon=qdbusviewer-qt4.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF

cat > $BUILDDIR/usr/share/applications/qtconfig-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Config 
Comment=Configure Qt4 behavior, styles, fonts
Exec=$QT4LINK/bin/qtconfig
Icon=qt4logo.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Settings;
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7), alsa-lib (>= 1.0.28), MesaLib (>= 10.2.7), \
CA (>= 7.6), DBus (>= 1.8.8), GLib (>= 2.40.0), ICU (>= 53.1), \
libjpeg-turbo (>= 1.3.1), libmng (>= 2.0.2), libpng (>= 1.6.13), \
LibTIFF (>= 4.0.3), OpenSSL (>= 1.0.1i), SQLite (>= 3.8.6), PulseAudio (>= 5.0)
Description: Qt toolkit
 Qt is a cross-platform application framework that is widely used for
 developing application software with a graphical user interface (GUI) (in
 which cases Qt is classified as a widget toolkit), and also used for
 developing non-GUI programs such as command-line tools and consoles for
 servers. One of the major users of Qt is KDE.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
add_ld_conf() {
    pattern="^\s*\/opt\/qt4\/lib\s*$"
    file=/etc/ld.so.conf
    line="/opt/qt4/lib"
    addline_unique "$pattern" "$line" $file
    ldconfig
}'

POSTRM_FUNC_DEF='
del_ld_conf() {
    pattern="^\s*\/opt\/qt4\/lib\s*$"
    file=/etc/ld.so.conf
    delline "$pattern" $file
}'

POSTINST_CONF_DEF='add_ld_conf'
POSTRM_CONF_DEF='del_ld_conf'
}

build
