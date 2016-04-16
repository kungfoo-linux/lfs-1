#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/android-ndk.sh << "EOF"
export NDK_HOME=/opt/android-ndk
export NDKROOT=$NDK_HOME
export PATH=$PATH:$NDK_HOME
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: android-sdk (>= 22.6)
Description: Android NDK
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF="
# srcfil under: android-sdk-22.6/plugins/NDK

if [ \"\`uname -m\`\" = \"x86_64\" ]; then
	srcfil=android-ndk-r10d-linux-x86_64.bin
else
	srcfil=android-ndk-r10d-linux-x86.bin
fi
"

POSTINST_CONF_DEF='
	rm -rf /opt/{android-ndk-r10d,android-ndk}

        echo "start extracting files ..."
	cd /opt
	./$srcfil
	ln -v -nsf android-ndk-r10d /opt/android-ndk
	'

POSTRM_CONF_DEF='rm -rf /opt/{android-ndk-r10d,android-ndk}'
}

build
