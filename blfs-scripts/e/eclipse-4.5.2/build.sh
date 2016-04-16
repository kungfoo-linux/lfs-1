#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Eclipse IDE for Java Developers
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
ARCH=`uname -m`
if [ "$ARCH" = "x86_64" ]; then
	srcfil=eclipse-java-mars-2-linux-gtk-x86_64.tar.gz
else
	srcfil=eclipse-java-mars-2-linux-gtk.tar.gz
fi
'

POSTINST_CONF_DEF='
	rm -rf /opt/eclipse

	echo "start extracting files ..."
	tar -xf $srcfil -C /opt

cat > /opt/eclipse/eclipse.desktop << "EOF"
[Desktop Entry]
Version=4.5.2
Type=Application
Terminal=false
Icon=/opt/eclipse/icon.xpm
Exec=/opt/eclipse/eclipse
Name=Eclipse
Comment=Eclipse IDE
EOF
chmod 755 /opt/eclipse/eclipse.desktop

if [ -d "/usr/share/applications" ]; then
    ln -sfv /opt/eclipse/eclipse.desktop /usr/share/applications/
fi

	chown -R root:root /opt/eclipse
'

POSTRM_CONF_DEF="
rm -rf /opt/eclipse
rm -f /usr/share/applications/eclipse.desktop
"
}

build
