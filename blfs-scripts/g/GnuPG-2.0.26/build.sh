#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gnupg-2.0.26.tar.bz2
srcdir=gnupg-2.0.26
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-symcryptrun \
	--docdir=/usr/share/doc/gnupg-2.0.26
make
makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi
makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/gnupg-2.0.26/html
install -v -m644    doc/gnupg_nochunks.html \
	$BUILDDIR/usr/share/doc/gnupg-2.0.26/gnupg.html
install -v -m644    doc/*.texi doc/gnupg.txt \
	$BUILDDIR/usr/share/doc/gnupg-2.0.26

for f in gpg gpgv
do
	ln -svf ${f}2.1 $BUILDDIR/usr/share/man/man1/$f.1
	ln -svf ${f}2   $BUILDDIR/usr/bin/$f
done
unset f

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Pth (>= 2.0.7), Libassuan (>= 2.1.2), libgcrypt (>= 1.6.2), \
 Libksba (>= 1.3.0)
Recommends: PINEntry (>= 0.8.3)
Suggests: OpenLDAP-2.4.39, libusb-compat-0.1.5, cURL-7.37.1, GNU_adns, MTA 
Description: complete and free implementation of the OpenGPG standard
 The GnuPG package is GNU's tool for secure communication and data storage. It
 can be used to encrypt data and to create digital signatures. It includes an
 advanced key management facility and is compliant with the proposed OpenPGP
 Internet standard as described in RFC2440 and the S/MIME standard as
 described by several RFCs. GnuPG 2 is the stable version of GnuPG integrating
 support for OpenPGP and S/MIME.
 .
 [addgnupghome] is used to create and populate user's ~/.gnupg directories.
 .
 [applygnupgdefaults] is a wrapper script used to run gpgconf with the 
 --apply-defaults parameter on all user's GnuPG home directories.
 .
 [gpg-agent] is a daemon used to manage secret (private) keys independently 
 from any protocol. It is used as a backend for gpg2 and gpgsm as well as 
 for a couple of other utilities.
 .
 [gpg-connect-agent] is a utility used to communicate with a running gpg-agent.
 .
 [gpg] (optional) is a symlink to gpg2 for compatibility with the first 
 version of GnuPG.
 .
 [gpg2] is the OpenPGP part of the GNU Privacy Guard (GnuPG). It is a tool 
 used to provide digital encryption and signing services using the OpenPGP 
 standard.
 .
 [gpgconf] is a utility used to automatically and reasonable safely query 
 and modify configuration files in the ~/.gnupg home directory. It is 
 designed not to be invoked manually by the user, but automatically by 
 graphical user interfaces.
 .
 [gpgparsemail] is a utility currently only useful for debugging. Run it 
 with --help for usage information.
 .
 [gpgsm] is a tool similar to gpg2 used to provide digital encryption and
 signing services on X.509 certificates and the CMS protocol. It is mainly 
 used as a backend for S/MIME mail processing.
 .
 [gpgsm-gencert.sh] is a simple tool used to interactively generate a 
 certificate request which will be printed to stdout.
 .
 [gpgv] (optional) is a symlink to gpgv2 for compatibility with the first 
 version of GnuPG.
 .
 [gpgv2] is a verify only version of gpg2.
 .
 [kbxutil] is used to list, export and import Keybox data.
 .
 [scdaemon] is a daemon used to manage smartcards. It is usually invoked by 
 gpg-agent and in general not used directly.
 .
 [symcryptrun] is a simple symmetric encryption tool.
 .
 [watchgnupg] is used to listen to a Unix Domain socket created by any of 
 the GnuPG tools. 
EOF
}

build
