#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

# The following sequences are recognized by agetty (the program which usually
# parses /etc/issue). This information is from man agetty where you can find
# extra information about the logon process.

# The issue file can contain certain character sequences to display various
# information. All issue sequences consist of a backslash (\) immediately
# followed by one of the letters explained below (so \d in /etc/issue would
# insert the current date).

# b   Insert the baudrate of the current line.
# d   Insert the current date.
# s   Insert the system name, the name of the operating system.
# l   Insert the name of the current tty line.
# m   Insert the architecture identifier of the machine, e.g., i686.
# n   Insert the nodename of the machine, also known as the hostname.
# o   Insert the domainname of the machine.
# r   Insert the release number of the kernel, e.g., 2.6.11.12.
# t   Insert the current time.
# u   Insert the number of current users logged in.
# U   Insert the string "1 user" or "<n> users" where <n> is the
#     number of current users logged in.
#     v   Insert the version of the OS, e.g., the build-date etc.

build_src() {
mkdir -pv $BUILDDIR
}

configure() {
mkdir -pv $BUILDDIR/etc
cat > $BUILDDIR/etc/issue << "EOF"
LFS 7.6 \n \l
Kernel \r on an \m
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Priority: required
Essential: yes
Description: The login message and identification file.
EOF
}

build
