#!/tools/bin/bash -e
. ../lfs.comm

# Creating Directories
create_dirs() {
    mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt}
    mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
    install -dv -m 0750 /root
    install -dv -m 1777 /tmp /var/tmp
    mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -v  /usr/libexec
    mkdir -pv /usr/{,local/}share/man/man{1..8}
    mkdir -pv /mnt/{lfs,usb,data}

    case $(uname -m) in
        x86_64) ln -sv lib /lib64
            ln -sv lib /usr/lib64
            ln -sv lib /usr/local/lib64 ;;
    esac

    mkdir -v /var/{log,mail,spool}
    ln -sv /run /var/run
    ln -sv /run/lock /var/lock
    mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
}

# Creating Essential Files and symlinks
create_essential_files() {
    # Some programs use hard-wired paths to programs which do not exist yet.
    # In order to satisfy these programs, create a number of symbolic links
    # which will be replaced by real files throughout the course of this
    # chapter after the software has been installed:
    ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
    ln -sv /tools/bin/perl /usr/bin
    ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
    ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
    sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
    ln -sv bash /bin/sh
    ln -sv /proc/self/mounts /etc/mtab

    # In order for user root to be able to login and for the name "root" to
    # be recognized, there must be relevant entries in the /etc/passwd and
    # /etc/group files.

    # Create the /etc/passwd file
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
		
    # Create the /etc/group file
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

    # The login, agetty, and init programs (and others) use a number of log
    # files to record information such as who was logged into the system and
    # when.
    # However, these programs will not write to the log files if they do not
    # already exist. Initialize the log files and give them proper permissions:
    touch /var/log/{btmp,lastlog,wtmp}
    chgrp -v utmp /var/log/lastlog
    chmod -v 664  /var/log/lastlog
    chmod -v 600  /var/log/btmp
}

configure() {
    create_dirs
    create_essential_files
}

build
