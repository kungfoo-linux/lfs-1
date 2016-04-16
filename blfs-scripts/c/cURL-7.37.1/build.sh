#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=curl-7.37.1.tar.bz2
srcdir=curl-7.37.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--enable-threaded-resolver
make
make DESTDIR=$BUILDDIR install

find docs \( -name "Makefile*" -o -name "*.1" -o -name "*.3" \) -exec rm {} \;
install -v -d -m755 $BUILDDIR/usr/share/doc/curl-7.37.1
cp -v -R docs/* $BUILDDIR/usr/share/doc/curl-7.37.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: CA (= 7.6), OpenSSL (>= 1.0.1i)
Description: a tool for transferring data from URLs
 The cURL package contains a utility and a library used for transferring files
 with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS,
 SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to both
 download and upload files can be incorporated into other programs to support
 functions like streaming media.
 .
 [curl]
 is a command line tool for transferring files with URL syntax.
 .
 [curl-config]
 prints information about the last compile, like libraries linked to and
 prefix setting.
 .
 [libcurl.so]
 provides the API functions required by curl and other programs. 
EOF
}

build

# Build on Windows xp (use visual Studio 2005):
# 1). Unzip the tarball to a directory, for example C:\.
# 2). Open DOS console window, change the directory to 
#    "C:\Program Files\Microsoft Visual Studio 8\VC\bin", execute the command
#    "vcvars32.bat" to setting a proper environment.
# 3). Open "vc6curl.dsw" with VC2005 (when prompt to convert the project,
#    click Yes To All). Select "DLL Release" configuration and compile it, if
#    all is well, it will generate "libcurl_imp.lib", "libcurl.dll" in 
#    "C:\curl-7.37.1\lib\DLL_Release" directory, and "curl.exe" in
#    "C:\curl-7.37.1\src\DLL-Release", move them to "C:\curl-7.37.1\lib". And
#    add "C:\curl-7.37.1\lib" to your system environment variables.
#
# If you want to know more detial information, for example, compile with zlib
# or SSL support, please refer the document with "docs/INSTALL".
#
# Setting Visual Studio 2005 environment:
# 1). Open VC2005, click the menu Tools->Options, position to 
#    "Projects and Solutions->VC++ Directories",and add:
#        include files: C:\curl-7.37.1\include
#        Library files: C:\curl-7.37.1\lib
#        Source files:  C:\curl-7.37.1\src
#
# In your property page, select "Configuration" to "All Configurations", and
# navigate to "Configuration Properties->Linker->Input", in
# "Additional Dependencies", add the static-link library "libcurl_imp.lib".
