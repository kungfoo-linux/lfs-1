#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=icewm-1.3.8.tar.gz
srcdir=icewm-1.3.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/^LIBS/s/\(.*\)/\1 -lfontconfig/' src/Makefile.in

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR install-docs
make DESTDIR=$BUILDDIR install-man
make DESTDIR=$BUILDDIR install-desktop

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-Server (>= 1.16.0), gdk-pixbuf (>= 2.30.8)
Description: wonderful Win95-OS/2-Motif-like window manager
 IceWm is a Window Manager for X Window System. It is fast and
 memory-efficient, and it provides many different looks including Windows'95,
 OS/2 Warp 3,4, Motif. It tries to take the best features of the above
 systems. Additional features include  multiple workspaces, opaque
 move/resize, task bar, window list, mailbox status, digital clock.
 .
 If IceWM is the only Window Manager you want to use, you can start it with an
 .xinitrc file in your home folder. Be sure to backup your current .xinitrc
 before proceeding:
      echo icewm-session > ~/.xinitrc
 .
 [icehelp]
 is used to display the html manual.
 .
 [icesh]
 is a command-line window manager which can be used in ~/.icewm/startup.
 .
 [icewm]
 is the window manager.
 .
 [icewm-session]
 runs icewmbg, icewm, icewmtray, startup, shutdown (i.e. startup and shutdown
 scripts are run if installed).
 .
 [icewm-set-gnomewm]
 is a script to set the GNOME to icewm using gconftool.
 .
 [icewmbg]
 is used to set the background, according to the various DesktopBackground
 settings in the preferences.
 .
 [icewmhint]
 is used internally.
 .
 [icewmtray]
 provides the tray.
EOF
}

build
