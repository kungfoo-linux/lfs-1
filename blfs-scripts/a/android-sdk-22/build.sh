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
	tar -xf android-sdk_r22.6.2-linux.tgz -C /opt
	mv /opt/android-sdk-linux /opt/android-sdk

	for file in android-22_r02.tar.xz \
		build-tools_r22.0.1-linux.tar.xz \
		docs-22_r01.tar.xz \
		platform-tools_r22-linux.tar.xz \
		samples-22_r06.tar.xz \
		sources-22_r01.tar.xz \
		support_r19.1.tar.xz \
		system-images-arm-22_r01.tar.xz; do
		tar -xf packages/$file -C /opt/android-sdk
	done

	chown -R root:root /opt/android-sdk
	find /opt/android-sdk -type d | xargs chmod 755
	find /opt/android-sdk -type f -perm -070 | xargs chmod 755
	find /opt/android-sdk -type f -perm 660 | xargs chmod 644
	'

POSTRM_CONF_DEF='rm -rf /opt/android-sdk'
}

build
