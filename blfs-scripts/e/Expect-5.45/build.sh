#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=expect5.45.tar.gz
srcdir=expect5.45
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr       \
	--with-tcl=/usr/lib     \
	--enable-shared         \
	--mandir=/usr/share/man \
	--with-tclinclude=/usr/include
make
make DESTDIR=$BUILDDIR install

ln -svf expect5.45/libexpect5.45.so $BUILDDIR/usr/lib

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Tcl (>= 8.6.2), Tk (>= 8.6.2)
Description: Automates interactive applications
 Expect is a tool for automating interactive applications according to a
 script. Following the script, Expect knows what can be expected from a
 program and what the correct response should be. Expect is also useful for
 testing these same applications. And by adding Tk, you can also wrap
 interactive applications in X11 GUIs. An interpreted language provides
 branching and high-level control structures to direct the dialogue. In
 addition, the user can take control and interact directly when desired,
 afterward returning control to the script.
 .
 [autoexpect]
 generates an Expect script from watching a session.
 .
 [autopasswd]
 is a wrapper to make passwd(1) be non-interactive.
 .
 [cryptdir]
 encrypts all files in a directory.
 .
 [decryptdir]
 decrypts all files in a directory.
 .
 [dislocate]
 allows processes to be disconnected and reconnected to a terminal.
 .
 [expect]
 is a program that “talks” to other interactive programs according to a
 script.
 .
 [ftp-rfc]
 retrieves an RFC (or the index) from UUNET.
 .
 [kibitz]
 allows two (or more) people to interact with one shell (or any arbitrary
 program).
 .
 [lpunlock]
 unhangs a printer which claims it is “waiting for lock”.
 .
 [mkpasswd]
 generates passwords and can apply them automatically to users.
 .
 [passmass]
 changes a password on multiple machines.
 .
 [rftp]
 is much like ftp except it uses ~g and ~p instead of mget and mput.
 .
 [rlogin-cwd]
 is rlogin except it uses the local current directory as the current working
 directory on the remote machine.
 .
 [timed-read]
 reads a complete line from stdin and aborts after a given number of seconds.
 .
 [timed-run]
 runs a program for a given amount of time.
 .
 [unbuffer]
 disables the output buffering that occurs when program output is redirected.
 .
 [weather]
 retrieves a weather report (courtesy University of Michigan) for a given city
 or geographical area.
 .
 [multixterm]
 creates multiple xterms that can be driven together or separately.
 .
 [tknewsbiff]
 pops up a window when there is unread news in your favorite newsgroups and
 removes the window after you've read the news.
 .
 [tkpasswd]
 is a script to change passwords using expect and Tk.
 .
 [xkibitz]
 allows users in separate xterms to share one shell (or any program that runs
 in an xterm).
 .
 [xpstat]
 is a script that acts as a front-end for xpilot.
 .
 [libexpect5.45.so]
 contains functions that allow Expect to be used as a Tcl extension or to be
 used directly from C or C++ (without Tcl). 
EOF
}

build
