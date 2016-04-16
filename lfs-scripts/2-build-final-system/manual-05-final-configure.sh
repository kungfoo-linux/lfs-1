#!/bin/bash -e
. ../lfs.comm

# Install the LFS-Bootscripts
# The LFS-Bootscripts package contains a set of scripts to start/stop the
# LFS system at bootup/shutdown.
install_bootscripts() {
    srcfil=lfs-bootscripts-20140815.tar.bz2
    srcdir=lfs-bootscripts-20140815

    tar -xf $LFSSRC/$srcfil && cd $srcdir
    make install
    cd .. && rm -rf $srcdir
}

# General Network Configuration
network_config() {
    # The following command create a sample file for the eth0 device 
    # with a static IP address:
cat > /etc/sysconfig/ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.10
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF

    # If the system is going to be connected to the Internet, it will 
    # need some means of Domain Name Service (DNS) name resolution to 
    # resolve Internet domain names to IP address, and vice versa. 
    # This is best achieved by placing the IP address of the DNS server, 
    # available from the ISP or network administrator, into 
    # /etc/resolv.conf. Create the file by running the following:
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

#domain <Your Domain Name>
#nameserver <IP address of your primary nameserver>
#nameserver <IP address of your secondary nameserver>
nameserver 192.168.1.1

# End /etc/resolv.conf
EOF

    # During the boot process, the file /etc/hostname is used for 
    # establishing the system's hostname. Create the file by running:
    echo "fangxm" > /etc/hostname

    # Decide on the IP address, fully-qualified domain name (FQDN), and 
    # possible aliases for use in the /etc/hosts file. Create the file 
    # by running:
    echo "127.0.0.1 localhost fangxm" > /etc/hosts
}

# System V Bootscript Configuration
systemv_bootscript() {
    # During the kernel initialization, the first program that is run 
    # is either specified on the command line or, by default init. 
    # This program reads the initialization file /etc/inittab. 
    # Create this file with:
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

#ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

    # Configuring the system clock. Create a new file /etc/sysconfig/clock 
    # by running the following:
    # Note, the CLOCKPARAMS and UTC paramaters may be alternatively set 
    # in the /etc/sysconfig/rc.site file.
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=0

# Set this to any options you might need to give to hwclock, 
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

    # The optional /etc/sysconfig/rc.site file contains settings that 
    # are automatically set for each SystemV boot script. It can 
    # alternatively set the values specified in the hostname, console, 
    # and clock files in the /etc/sysconfig/ directory. If the associated 
    # variables are present in both these separate files and rc.site, 
    # the values in the script specific files have precedence.

    # rc.site also contains parameters that can customize other aspects 
    # of the boot process. Setting the IPROMPT variable will enable 
    # selective running of bootscripts. Other options are described in 
    # the file comments. 

    # Add rc.local and shutdown.local:
    touch /etc/rc.d/rc.local
    chmod +x /etc/rc.d/rc.local
    echo "setfont LatGrkCyr-8x16" >> /etc/rc.d/rc.local

    ln -sv /etc/rc.d/rc.local /etc/rc.d/rc3.d/S999rc.local
    ln -sv /etc/rc.d/rc.local /etc/rc.d/rc4.d/S999rc.local
    ln -sv /etc/rc.d/rc.local /etc/rc.d/rc5.d/S999rc.local

    touch /etc/rc.d/shutdown.local
    chmod +x /etc/rc.d/shutdown.local

    ln -sv /etc/rc.d/shutdown.local /etc/rc.d/rc6.d/K00shutdown.local
}

# The Bash Shell Startup Files
shell_startupfiles() {
    # To find the proper locale with your system, issue the commmand:
    #   locale -a
    # In the result list, I choose "zh_CN.utf8" as my locale.
cat > /etc/profile << "EOF"
# Begin /etc/profile

#export LC_ALL=zh_CN.UTF-8

# End /etc/profile
EOF

cat > ~/.bash_profile << "EOF"
# Begin .bash_profile

# user specific environment and startup programs
export PATH=$PATH:$HOME/bin:/usr/local/bin
PS1="\h# "
set -o ignoreeof

# define aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls --color'
alias la='ls -a'
alias lf='ls -FA'
alias ll='ls -lA'
alias less='less --quiet'
alias more='more -d'

unset USERNAME

# End .bash_profile
EOF
}

# The /etc/inputrc File
# The inputrc file handles keyboard mapping for specific situations. This
# file is the startup file used by Readline - the input-related library - used
# by Bash and most other shells.
# Most people do not need user-specific keyboard mappings so the command below
# creates a global /etc/inputrc used by everyone who logs in. If you later
# decide you need to override the defaults on a per-user basis, you can create 
# a .inputrc file in the user's home directory with the modified mappings.
# Below is a generic global inputrc along with comments to explain what the
# various options do. Note that comments cannot be on the same line as
# commands.
inputrc_file() {
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF
}

# The /etc/fstab File
# The /etc/fstab file is used by some programs to determine where file systems
# are to be mounted by default, in which order, and which must be checkd (for
# integrity errors) prior to mounting.
fstab_file() {
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system mount-point type     options             dump fsck order
/dev/sda1     /           ext4     defaults            1    1
proc          /proc       proc     nosuid,noexec,nodev 0    0
sysfs         /sys        sysfs    nosuid,noexec,nodev 0    0
devpts        /dev/pts    devpts   gid=5,mode=620      0    0
tmpfs         /run        tmpfs    defaults            0    0
devtmpfs      /dev        devtmpfs mode=0755,nosuid    0    0

# End /etc/fstab
EOF
}

configure() {
    install_bootscripts
    network_config
    systemv_bootscript
    shell_startupfiles
    inputrc_file
    fstab_file
} 

build
