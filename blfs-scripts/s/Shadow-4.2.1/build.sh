#!/bin/bash -e
. ../../blfs.comm

# [Important]
# The installation commands shown below are for installations where Linux-PAM
# has been installed (with or without a CrackLib installation) and Shadow is
# being reinstalled to support the Linux-PAM installation.
#
# If you are reinstalling Shadow to provide strong password support using the
# CrackLib library without using Linux-PAM, ensure you add the --with-libcrack
# parameter to the configure script below and also issue the following command:
#     sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs

build_src() {
srcfil=shadow-4.2.1.tar.xz
srcdir=shadow-4.2.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \; &&

sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	-e 's@/var/spool/mail@/var/mail@' etc/login.defs &&

sed -i 's/1000/999/' etc/useradd &&

./configure --sysconfdir=/etc --with-group-name-max-length=32
make
make DESTDIR=$BUILDDIR install
mv -v $BUILDDIR/usr/bin/passwd $BUILDDIR/bin

cleanup_src .. $srcdir
}

configure() {
# [Configuring Linux-PAM to Work with Shadow]
# The rest of this page is devoted to configuring Shadow to work properly 
# with Linux-PAM. If you do not have Linux-PAM installed, and you 
# reinstalled Shadow to support strong passwords via the CrackLib library, 
# no further configuration is required.

# 1. Shadow's stock configuration for the useradd utility may not be 
# desirable for your installation. One default parameter causes useradd to 
# create a mailbox file for any newly created user. useradd will make the 
# group ownership of this file to the mail group with 0660 permissions.
# If you would prefer that these mailbox files are not created by useradd, 
# issue the following command as the root user:

sed -i 's/yes/no/' $BUILDDIR/etc/default/useradd

# 2. Configuring /etc/login.defs
# The login program currently performs many functions which Linux-PAM 
# modules should now handle. The following sed command will comment out the 
# appropriate lines in /etc/login.defs, and stop login from performing these 
# functions (a backup file named /etc/login.defs.orig is also created to 
# preserve the original file's contents).

install -v -m644 $BUILDDIR/etc/login.defs $BUILDDIR/etc/login.defs.orig &&
for FUNCTION in FAIL_DELAY               \
		FAILLOG_ENAB             \
		LASTLOG_ENAB             \
		MAIL_CHECK_ENAB          \
		OBSCURE_CHECKS_ENAB      \
		PORTTIME_CHECKS_ENAB     \
		QUOTAS_ENAB              \
		CONSOLE MOTD_FILE        \
		FTMP_FILE NOLOGINS_FILE  \
		ENV_HZ PASS_MIN_LEN      \
		SU_WHEEL_ONLY            \
		CRACKLIB_DICTPATH        \
		PASS_CHANGE_TRIES        \
		PASS_ALWAYS_WARN         \
		CHFN_AUTH ENCRYPT_METHOD \
		ENVIRON_FILE
do
    sed -i "s/^${FUNCTION}/# &/" $BUILDDIR/etc/login.defs
done

# 3. Configuring the /etc/pam.d/ Files
# As mentioned previously in the Linux-PAM instructions, Linux-PAM has two 
# supported methods for configuration. The commands below assume that you've 
# chosen to use a directory based configuration, where each program has its 
# own configuration file. You can optionally use a single /etc/pam.conf 
# configuration file by using the text from the files below, and supplying 
# the program name as an additional first field for each line.

# As the root user, replace the following Linux-PAM configuration files in 
# the /etc/pam.d/ directory (or add the contents to the /etc/pam.conf file) 
# using the following commands:

# 3.1. system-account
cat > $BUILDDIR/etc/pam.d/system-account << "EOF"
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

# 3.2. system-auth
cat > $BUILDDIR/etc/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

# 3.3. system-passwd (with cracklib)
cat > $BUILDDIR/etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# check new passwords for strength (man pam_cracklib)
password  required    pam_cracklib.so   type=Linux retry=3 difok=5 \
                                        difignore=23 minlen=9 dcredit=1 \
                                        ucredit=1 lcredit=1 ocredit=1 \
                                        dictpath=/lib/cracklib/pw_dict
# use sha512 hash for encryption, use shadow, and use the
# authentication token (chosen password) set by pam_cracklib
# above (or any previous modules)
password  required    pam_unix.so       sha512 shadow use_authtok

# End /etc/pam.d/system-password
EOF

# Note, In its default configuration, owing to credits, pam_cracklib will 
# allow multiple case passwords as short as 6 characters, even with the 
# minlen value set to 11. You should review the pam_cracklib(8) man page 
# and determine if these default values are acceptable for the security of 
# your system.

# 3.4. system-session
cat > $BUILDDIR/etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF

# 3.5. login
cat > $BUILDDIR/etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login

# Set failure delay before next prompt to 3 seconds
auth      optional    pam_faildelay.so  delay=3000000

# Check to make sure that the user is allowed to login
auth      requisite   pam_nologin.so

# Check to make sure that root is allowed to login
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth      required    pam_securetty.so

# Additional group memberships - disabled by default
#auth      optional    pam_group.so

# include the default auth settings
auth      include     system-auth

# check access for the user
account   required    pam_access.so

# include the default account settings
account   include     system-account

# Set default environment variables for the user
session   required    pam_env.so

# Set resource limits for the user
session   required    pam_limits.so

# Display date of last login - Disabled by default
#session   optional    pam_lastlog.so

# Display the message of the day - Disabled by default
#session   optional    pam_motd.so

# Check user's mail - Disabled by default
#session   optional    pam_mail.so      standard quiet

# include the default session and password settings
session   include     system-session
password  include     system-password

# End /etc/pam.d/login
EOF

# 3.6. passwd
cat > $BUILDDIR/etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd

password  include     system-password

# End /etc/pam.d/passwd
EOF

# 3.7. su
cat > $BUILDDIR/etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su

# always allow root
auth      sufficient  pam_rootok.so
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/su
EOF

# 3.8. chage
cat > $BUILDDIR/etc/pam.d/chage << "EOF"
#Begin /etc/pam.d/chage

# always allow root
auth      sufficient  pam_rootok.so

# include system defaults for auth account and session
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so

# End /etc/pam.d/chage
EOF

# 3.9. Other common programs
for PROGRAM in chfn chgpasswd chpasswd chsh groupadd groupdel \
	groupmems groupmod newusers useradd userdel usermod
do
    install -v -m644 $BUILDDIR/etc/pam.d/chage $BUILDDIR/etc/pam.d/${PROGRAM}
    sed -i "s/chage/$PROGRAM/" $BUILDDIR/etc/pam.d/${PROGRAM}
done

# 3.10. other
# Currently, /etc/pam.d/other is configured to allow anyone with an account 
# on the machine to use PAM-aware programs without a configuration file for 
# that program. After testing Linux-PAM for proper configuration, install a 
# more restrictive other file so that program-specific configuration files 
# are required:
cat > $BUILDDIR/etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Linux-PAM (>= 1.1.8), CrackLib (>= 2.9.1)
Description: Shadow password suite
 [chage] Used to change the maximum number of days between obligatory 
 password changes
 .
 [chfn] Used to change a user's full name and other information
 .
 [chgpasswd] Used to update group passwords in batch mode
 .
 [chpasswd] Used to update user passwords in batch mode
 .  
 [chsh] Used to change a user's default login shell
 .  
 [expiry] Checks and enforces the current password expiration policy
 .
 [faillog] Is used to examine the log of login failures, to set a maximum 
 number of failures before an account is blocked, or to reset the failure 
 count
 .
 [gpasswd] Is used to add and delete members and administrators to groups
 .
 [groupadd] Creates a group with the given name
 .
 [groupdel] Deletes the group with the given name
 .
 [groupmems] Allows a user to administer his/her own group membership list 
 without the requirement of super user privileges.
 .
 [groupmod] Is used to modify the given group's name or GID
 .
 [grpck] Verifies the integrity of the group files /etc/group and /etc/gshadow
 .
 [grpconv] Creates or updates the shadow group file from the normal group file
 .
 [grpunconv] Updates /etc/group from /etc/gshadow and then deletes the latter
 .
 [lastlog] Reports the most recent login of all users or of a given user
 .
 [login] Is used by the system to let users sign on
 .
 [logoutd] Is a daemon used to enforce restrictions on log-on time and ports
 .
 [newgrp] Is used to change the current GID during a login session
 .
 [newusers] Is used to create or update an entire series of user accounts
 .
 [nologin] Displays a message that an account is not available. Designed to 
 be used as the default shell for accounts that have been disabled
 .
 [passwd] Is used to change the password for a user or group account
 .
 [pwck] Verifies the integrity of the password files /etc/passwd and 
 /etc/shadow
 .
 [pwconv] Creates or updates the shadow password file from the normal 
 password file
 .
 [pwunconv] Updates /etc/passwd from /etc/shadow and then deletes the latter
 .
 [sg] Executes a given command while the user's GID is set to that of the 
 given group
 .
 [su] Runs a shell with substitute user and group IDs
 .
 [useradd] Creates a new user with the given name, or updates the default 
 new-user information
 .
 [userdel] Deletes the given user account
 .
 [usermod] Is used to modify the given user's login name, User 
 Identification (UID), shell, initial group, home directory, etc.
 .
 [vigr] Edits the /etc/group or /etc/gshadow files
 .
 [vipw] Edits the /etc/passwd or /etc/shadow files 
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
	# Instead of using the /etc/login.access file for controlling access 
	# to the system, Linux-PAM uses the pam_access.so module along with 
	# the /etc/security/access.conf file. Rename the /etc/login.access 
	# file using the following command:

	[ -f /etc/login.access ] && mv -v /etc/login.access{,.NOUSE}

	# Instead of using the /etc/limits file for limiting usage of system 
	# resources, Linux-PAM uses the pam_limits.so module along with the 
	# /etc/security/limits.conf file. Rename the /etc/limits file using 
	# the following command:

	[ -f /etc/limits ] && mv -v /etc/limits{,.NOUSE}
	'

POSTRM_CONF_DEF='
	# rename files
	[ -f /etc/login.access.NOUSE ] && mv -v /etc/login.access{.NOUSE,}
	[ -f /etc/limits.NOUSE ] && mv -v /etc/limits{.NOUSE,}
	'
}

build
