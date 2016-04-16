#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

configure() {
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/android-sdk.sh << "EOF"
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenJDK (>= 1.6)
Description: Android SDK
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	rm -rf /opt/android-sdk

	echo "start extracting files ..."
	cd /opt
	tar -xf android-sdk-19-linux.tar.xz -C /opt
	mv /opt/android-sdk-linux /opt/android-sdk

	for file in android-19_r03.tar.xz \
		build-tools_r19.0.3-linux.tar.xz \
		docs-19_r02.tar.xz \
		extras.tar.xz \
		platform-tools_r19.0.1-linux.tar.xz \
		samples-19_r04.tar.xz \
		android-src-19_r02.tar.xz \
		system-images-armv7a-19_r03.tar.xz; do
		tar -xf packages/$file -C /opt/android-sdk
	done

	chown -R root:root /opt/android-sdk
	'

POSTRM_CONF_DEF='rm -rf /opt/android-sdk'
}

build
