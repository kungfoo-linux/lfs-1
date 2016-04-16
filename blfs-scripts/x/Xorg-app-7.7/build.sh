#!/bin/bash -e
. ../../blfs.comm

build_src() {
filelst=$BLFSSRC/$PKGLETTER/$CURDIR/app-7.7.md5
for package in $(grep -v '^#' $filelst | awk '{print $2}')
do
    srcfil=$BLFSSRC/$PKGLETTER/$CURDIR/app/$package
    packagedir=${package%.tar.bz2}

    tar -xf $srcfil
    pushd $packagedir

    case $packagedir in
        luit-[0-9]* )
            line1="#ifdef _XOPEN_SOURCE"
	    line2="#  undef _XOPEN_SOURCE"
	    line3="#  define _XOPEN_SOURCE 600"
	    line4="#endif"
 
	    sed -i -e "s@#ifdef HAVE_CONFIG_H@$line1\n$line2\n$line3\n$line4\n\n&@" sys.c
	    unset line1 line2 line3 line4
            ;;
    esac

    ./configure $XORG_CONFIG
    make
    make DESTDIR=$BUILDDIR install

    popd
    rm -rf $packagedir
done
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libpng (>= 1.6.13), MesaLib (>= 10.2.7), xbitmaps (>= 1.1.1), \
xcb-util (>= 0.3.9), Linux-PAM (>= 1.1.8)
Description: the expected app available in previous X Window implementations
 .
 [bdftopcf]
 converts an X font from Bitmap Distribution Format to Portable Compiled
 Format.
 .
 [iceauth]
 is the ICE authority file utility.
 .
 [luit]
 provides locale and ISO 2022 support for Unicode terminals.
 .
 [mkfontdir]
 creates an index of X font files in a directory.
 .
 [mkfontscale]
 creates an index of scalable font files for X.
 .
 [sessreg]
 manages utmp/wtmp entries for non-init clients.
 .
 [setxkbmap]
 sets the keyboard using the X Keyboard Extension.
 .
 [smproxy]
 is the Session Manager Proxy.
 .
 [x11perf]
 is an X11 server performance test program.
 .
 [x11perfcomp]
 is an X11 server performance comparison program.
 .
 [xauth]
 is the X authority file utility.
 .
 [xbacklight]
 adjusts backlight brightness using RandR extension.
 .
 [xcmsdb]
 is the Device Color Characterization utility for the X Color Management
 System.
 .
 [xcursorgen]
 creates an X cursor file from a collection of PNG images.
 .
 [xdpr]
 dumps an X window directly to a printer.
 .
 [xdpyinfo]
 is a display information utility for X.
 .
 [xdriinfo]
 queries configuration information of DRI drivers.
 .
 [xev]
 prints contents of X events.
 .
 [xgamma]
 alters a monitor's gamma correction through the X server.
 .
 [xhost]
 is a server access control program for X.
 .
 [xinput]
 is a utility to configure and test X input devices.
 .
 [xkbbell]
 is an XKB utility program that raises a bell event.
 .
 [xkbcomp]
 compiles an XKB keyboard description.
 .
 [xkbevd]
 is the XKB event daemon.
 .
 [xkbvleds]
 shows the XKB status of keyboard LEDs.
 .
 [xkbwatch]
 monitors modifier keys and LEDs.
 .
 [xkill]
 kills a client by its X resource.
 .
 [xlsatoms]
 lists interned atoms defined on the server.
 .
 [xlsclients]
 lists client applications running on a display.
 .
 [xmessage]
 displays a message or query in a window.
 .
 [xmodmap]
 is a utility for modifying keymaps and pointer button mappings in X.
 .
 [xpr]
 prints an X window dump.
 .
 [xprop]
 is a property displayer for X.
 .
 [xrandr]
 is a primitive command line interface to RandR extension.
 .
 [xrdb]
 is the X server resource database utility.
 .
 [xrefresh]
 refreshes all or part of an X screen.
 .
 [xset]
 is the user preference utility for X.
 .
 [xsetroot]
 is the root window parameter setting utility for X.
 .
 [xvinfo]
 prints out X-Video extension adaptor information.
 .
 [xwd]
 dumps an image of an X window.
 .
 [xwininfo]
 is a window information utility for X.
 .
 [xwud]
 is an image displayer for X.
EOF
}

build
