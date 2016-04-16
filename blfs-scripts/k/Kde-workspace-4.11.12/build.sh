#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kde-workspace-4.11.12.tar.xz
srcdir=kde-workspace-4.11.12
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DSYSCONF_INSTALL_DIR=/etc \
	-DCMAKE_BUILD_TYPE=Release \
	-DINSTALL_PYTHON_FILES_IN_PYTHON_PREFIX=TRUE \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

mkdir -p $BUILDDIR/usr/share/xsessions
ln -sf $KDE_PREFIX/share/apps/kdm/sessions/kde-plasma.desktop \
	$BUILDDIR/usr/share/xsessions/kde-plasma.desktop

uid=37
gid=37
install -o $uid -g $gid -dm755 $BUILDDIR/var/lib/kdm

cleanup_src .. $srcdir
}

configure() {
# To start KDE from the command prompt, you first need to modify your .xinitrc
# file:
mkdir -pv $BUILDDIR/root/
cat > $BUILDDIR/root/.xinitrc << EOF
# Begin .xinitrc

exec ck-launch-session dbus-launch --exit-with-session startkde

# End .xinitrc
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: kactivities (>= 4.13.3), qimageblitz (>= 0.0.6), \
xcb-util-image (>= 0.3.9), xcb-util-renderutil (>= 0.3.9), \
xcb-util-keysyms (>= 0.3.9), xcb-util-wm (>= 0.4.1)
Recommends: kdepimlibs (>= 4.14.1), Boost (>= 1.56.0), FreeType (>= 2.5.3), \
pciutils (>= 3.2.1), ConsoleKit (>= 0.4.6)
Suggests: libusb (>= 1.0.19), lm-sensors-3.3.5, QJson (>= 0.8.1)
Description: The KDE Workspace
 The Kde-workspace package contains components that are central to providing
 the KDE desktop environment. Of particular importance are KWin, the KDE
 window manager, and Plasma, which provides the workspace interface.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
# KDE comes with a graphical login interface called KDM (the KDE Display
# Manager), which provides a customizable graphical login at boot. To use KDM,
# you need to edit your /etc/inittab file (as the root user). First, setup
# run-level 5 to start KDM (adjust the path to kdm according to your system):
add_inittab() {
    pattern="^kd:5:respawn:"
    file=/etc/inittab
    line="kd:5:respawn:/usr/bin/kdm"
    addline_unique "$pattern" "$line" $file
}

change_level_3to5() {
    sed -i "s#id:3:initdefault:#id:5:initdefault:#" /etc/inittab
}
'

POSTRM_FUNC_DEF='
del_inittab() {
    pattern="^kd:5:respawn:"
    file=/etc/inittab
    delline "$pattern" $file
}

change_level_5to3() {
    sed -i "s#id:5:initdefault:#id:3:initdefault:#" /etc/inittab
}
'

POSTINST_CONF_DEF='
	if ! getent group "kdm" > /dev/null 2>&1 ; then
	    groupadd -g 37 kdm
	fi

	if ! getent passwd "kdm" > /dev/null 2>&1 ; then
            useradd -c "KDM Daemon Owner" -d /var/lib/kdm -g kdm \
	        -u 37 -s /bin/false kdm
	fi

	add_inittab
	change_level_3to5
	'

POSTRM_CONF_DEF='
	if getent passwd "kdm" > /dev/null 2>&1 ; then
	    userdel kdm
	fi

	if getent group "kdm" > /dev/null 2>&1 ; then
	    groupdel kdm
	fi

	del_inittab
	change_level_5to3
	'
}

build
