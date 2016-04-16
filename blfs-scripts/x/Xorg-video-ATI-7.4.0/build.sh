#!/bin/bash -e
. ../../blfs.comm

build_src() {
# For Direct Rendering to work with newer Radeon Cards (R300 and later
# chipsets), you need to enable the r300, r600 and radeonsi Gallium drivers at
# MesaLib build time. Also, some cards require Firmware to be available when
# the kernel driver is loaded. Firmware can be obtained from this site
# (http://people.freedesktop.org/~agd5f/radeon_ucode/).
#
# Glamor is required for "Southern Islands" and later GPUs but optional for
# R300 to R700, Evergreen and "Northern Islands" GPUs - see the link under
# "Glamor Acceleration" below.
#
# If you need to add firmware, install the file(s) and then point to them in
# the kernel configuration and recompile the kernel if necessary. To find out
# which firmware you need, consult the Decoder ring for engineering vs
# marketing names
# (http://wiki.x.org/wiki/RadeonFeature#Decoder_ring_for_engineering_vs_marketing_names).
# Download any firmware for your card which is named like:
# <ENGINEERING_NAME>_rlc.bin, etc. Note that for R600 and R700 family, generic
# R600_rlc.bin and R700_rlc.bin are necessary in adition to the model specific
# firmware, while for later generations (Evergreen, "Northern Islands" and
# probably "Southern Islands") you need the BTC_rlc.bin in adition to the
# model specific firmware. Below is an example for Radeon HD6470, which is
# "Northern Islands" GPU with a network card that also requires the firmware:
# ---------------------------------------------------------------------------------
#  CONFIG_EXTRA_FIRMWARE="radeon/BTC_rlc.bin radeon/CAICOS_mc.bin radeon/CAICOS_me.bin
#  radeon/CAICOS_pfp.bin radeon/CAICOS_smc.bin rtl_nic/rtl8168e-3.fw"
#  CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# ---------------------------------------------------------------------------------

srcfil=xf86-video-ati-7.4.0.tar.bz2
srcdir=xf86-video-ati-7.4.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '/ac_cv_header_glamor/s/\$ac_includes_default/#include \\"xorg-server.h\\"/' \
	-e '/GLAMOR_NO_DRI3/s/\(#include \)/\1\\"xorg-server.h\\"\n\1/' configure

./configure $XORG_CONFIG
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-Server (>= 1.16.0)
Description: X.Org Video Driver for ATI Radeon video cards
 The Xorg ATI Driver package contains the X.Org Video Driver for ATI Radeon
 video cards including all chipsets ranging from R100 to R900 and the newer
 RAxx chipsets.
 .
 IBM Thinkpad X31 ship the ATI card with type RV100/M6, it supported by this
 driver. Visit the http://dri.freedesktop.org/wiki/ATIRadeon/ page for more
 information.
 .
 Kernel configuration:
 --------------------------------------------------
 . Device Drivers  --->
 .     Graphics support  --->
 .         Direct Rendering Manager --->
 .           <*> ATI Radeon: Y or M
 --------------------------------------------------
 .
 [ati_drv.so]
 is a wrapper driver for ATI video cards that autodetects ATI video hardware
 and loads radeon, mach64 or r128 driver.
 .
 [radeon_drv.so]
 is an Xorg video driver for ATI Radeon based video cards.
EOF
}

build
