# section 2.4: build/etc/profile.d/umask.sh
# Setting the umask value is important for security. Here the default group 
# write permissions are turned off for system users and when the user name 
# and group name are not the same.

# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
    umask 002
else
    umask 022
fi
