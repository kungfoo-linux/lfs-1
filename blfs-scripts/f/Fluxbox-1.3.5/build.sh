#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fluxbox-1.3.5.tar.bz2
srcdir=fluxbox-1.3.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-Server (>= 1.16.0), DBus (>= 1.8.8), FriBidi (>= 0.19.6), \
Imlib2 (>= 1.4.6)
Description: Highly configurable and low resource X11 Window manager
 Fairly similar to blackbox, from which it is derived, but has been extended
 with features such as pwm-style window tabs, configurable key bindings,
 toolbar, and an iconbar. It also includes some cosmetic fixes over blackbox.
 .
 If Fluxbox is the only Window Manager you want to use, you can start it with
 an .xinitrc file in your home folder. Be sure to backup your current .xinitrc
 before proceeding:
      echo startfluxbox > ~/.xinitrc
 .
 [fluxbox]
 is a window manager for X11 based on Blackbox 0.61.0.
 .
 [fbsetbg]
 is a utility that sets the background image. It requires one of: display,
 Esetroot, wmsetbg, xv, qiv or xsri. It also requires which if Esetroot is
 found.
 .
 [fbsetroot]
 is a utility to change root window appearance based on the Blackbox
 application bsetroot.
 .
 [fluxbox-generate_menu]
 is a utility that generates a menu by scanning your PATH.
 .
 [startfluxbox]
 is a session startup script that allows for command executions prior to
 fluxbox starting.
 .
 [fbrun]
 displays a run dialog window.
 .
 [fluxbox-remote]
 provides command line access to key commands for Fluxbox.
EOF
}

build
