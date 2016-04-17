#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mysql-5.1.73.tar.gz
srcdir=mysql-5.1.73
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# There are a great many options available to ./configure.
# Check the output of the --help option for additional customization options.

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--libexecdir=/usr/sbin \
	--localstatedir=/srv/mysql \
	--enable-thread-safe-client \
	--enable-assembler \
	--enable-local-infile \
	--with-unix-socket-path=/var/run/mysql/mysql.sock \
	--without-debug \
	--without-readline \
	--with-plugins=innobase,myisam \
	--with-extra-charsets=all \
	--with-ssl
make
make DESTDIR=$BUILDDIR install

rm -rf $BUILDDIR/usr/{mysql-test,sql-bench}

pushd $BUILDDIR/usr/lib
ln -v -sf mysql/libmysqlclient{,_r}.so* .
popd
 
cleanup_src .. $srcdir
}

build_client() {
# As a programmer, maybe you only need a mysql client and some head files.

srcfil=mysql-5.1.73.tar.gz
srcdir=mysql-5.1.73
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--without-server \
	--enable-thread-safe-client \
	--enable-assembler \
	--with-unix-socket-path=/var/run/mysql/mysql.sock \
	--without-debug \
	--without-readline \
	--with-extra-charsets=all \
	--with-ssl
make

# Copy files you need:
mkdir -pv $BUILDDIR/usr/{bin,include/mysql,lib/mysql}
cp -r include $BUILDDIR/usr/include/mysql
cp client/mysql{,_upgrade,admin,binlog,check,dump,import,show,slap,test} \
	$BUILDDIR/usr/bin
cp -rfd libmysql/.libs/libmysqlclient.{a,so*} $BUILDDIR/usr/lib/mysql
cp -rfd libmysql_r/.libs/libmysqlclient_r.{a,so*} $BUILDDIR/usr/lib/mysql

cd $BUILDDIR/usr/lib
ln -svf mysql/libmysqlclient{,_r}.{a,so}* .

cleanup_src .. $srcdir
}

configure() {
# There are several default configuration files available in
# '/usr/share/mysql' which you can use. Create '/etc/my.cnf' using the
# following command:

mkdir -pv $BUILDDIR/etc
install -v -m644 $BUILDDIR/usr/share/mysql/my-medium.cnf $BUILDDIR/etc/my.cnf
sed -i -e s/^skip-federated/#skip-federated/ $BUILDDIR/etc/my.cnf

# MySQL will logger all operator log into the file 'mysql-bin.xxxx', it will
# lost many disk space. You can close this feature:
sed -i 's/^log-bin=/#log-bin=/g' $BUILDDIR/etc/my.cnf
sed -i 's/^binlog_format=/#binlog_format=/g' $BUILDDIR/etc/my.cnf
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: MySQL database server
 MySQL is a multi-user, multi-threaded SQL database server. MySQL is a
 client/server implementation consisting of a server daemon (mysqld) and many
 different client programs and libraries.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
show_note() {
    echo -e \
    " In mysql-5.1.73, not allow login the server on a remote machine by default.\n" \
    "1). First, start mysql with safe mode:\n" \
    "$ mysqld_safe --skip-grant-tables &\n" \
    "\n" \
    "2). login mysql and add the root user:\n" \
    "$ mysql -u root -p\n" \
    "\n" \
    "If you connect the MySQL server on a remote machine, the command is:\n" \
    "$ mysql -u root -h <hostname or IP address> -p\n" \
    "when prompt \"Enter password:\", press Enter to skip it.\n" \
    "\n" \
    "3). update the table:\n" \
    "mysql> use mysql\n" \
    "mysql> update user set host='%', password=PASSWORD('secret')\n" \
    "	    where host='localhost' and user='root';\n" \
    "mysql> delete from user where host!='%';\n" \
    "mysql> commit;\n" \
    "mysql> quit\n" \
    "\n" \
    "4). shutdown the mysql:\n" \
    "$ mysqladmin -p shutdown\n" \
    "\n" \
    "5). start mysql in normal mode:\n" \
    "mysqld_safe --user=mysql 2>&1 >/dev/null &"
}
'

POSTINST_CONF_DEF='
	# Add group and user
	if ! getent group "mysql" > /dev/null 2>&1 ; then
	    groupadd -g 40 mysql
	fi

	if ! getent passwd "mysql" > /dev/null 2>&1 ; then
	    useradd -c "MySQL Server" -d /dev/null -g mysql \
		-s /bin/false -u 40 mysql
	fi

	# Install a database and change the ownership to the
	# unprivileged user and group:
	db_dir="/srv/mysql/mysql"

	if [ ! -e $db_dir/db.MYD ]; then
	    mysql_install_db --user=mysql
	    chgrp -v mysql /srv/mysql{,/test,/mysql}
	    install -v -m775 -o mysql -g mysql -d /var/run/mysql
        fi

	# A default installation does not set up a password for the
	# administrator, so use the following command as the root user to
	# set one. Replace <new-password> with your own. 
	#mysqld_safe --user=mysql 2>&1 >/dev/null &
	#mysqladmin -u root password "secret"
	#mysqladmin -p shutdown

	show_note
	'

POSTRM_CONF_DEF='
	pidfile=/var/run/mysql/mysql.sock
        if [ -e $pidfile ]; then
	    mysqladmin -p shutdown
        fi

	if getent passwd "mysql" > /dev/null 2>&1 ; then
	    userdel mysql
	fi

	if getent group "mysql" > /dev/null 2>&1 ; then
	    groupdel mysql
	fi
	'
}

build
