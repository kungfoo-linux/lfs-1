#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libpaper_1.1.24+nmu3.tar.gz
srcdir=libpaper-1.1.24+nmu3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

configure() {
mkdir -pv $BUILDDIR/etc/libpaper.d

cat > $BUILDDIR/usr/bin/run-parts << "EOF"
#!/bin/sh
# run-parts:  Runs all the scripts found in a directory.
# from Slackware, by Patrick J. Volkerding with ideas borrowed
# from the Red Hat and Debian versions of this utility.

# keep going when something fails
set +e

if [ $# -lt 1 ]; then
  echo "Usage: run-parts <directory>"
  exit 1
fi

if [ ! -d $1 ]; then
  echo "Not a directory: $1"
  echo "Usage: run-parts <directory>"
  exit 1
fi

# There are several types of files that we would like to
# ignore automatically, as they are likely to be backups
# of other scripts:
IGNORE_SUFFIXES="~ ^ , .bak .new .rpmsave .rpmorig .rpmnew .swp"

# Main loop:
for SCRIPT in $1/* ; do
  # If this is not a regular file, skip it:
  if [ ! -f $SCRIPT ]; then
    continue
  fi
  # Determine if this file should be skipped by suffix:
  SKIP=false
  for SUFFIX in $IGNORE_SUFFIXES ; do
    if [ ! "$(basename $SCRIPT $SUFFIX)" = "$(basename $SCRIPT)" ]; then
      SKIP=true
      break
    fi
  done
  if [ "$SKIP" = "true" ]; then
    continue
  fi
  # If we've made it this far, then run the script if it's executable:
  if [ -x $SCRIPT ]; then
    $SCRIPT || echo "$SCRIPT failed."
  fi
done

exit 0
EOF

chmod -v 755 $BUILDDIR/usr/bin/run-parts

# set the default system paper size, for example, "A4":
cat > $BUILDDIR/etc/papersize << "EOF"
a4
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library for handling paper characteristics
 This package is intended to provide a simple way for applications to take
 actions based on a system or user-specified paper size.
 .
 [paperconf]
 print paper configuration information.
 .
 [paperconfig]
 configure the system default paper size.
 .
 [run-parts]
 run all the scripts found in a directory.
 .
 [libpaper.so]
 contains functions for interrogating the paper library.
EOF
}

build
