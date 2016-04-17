#!/bin/sh
set -e

# Required
# libaio-0.3.110
# libXp-1.0.2 

# creating the Oracle inventory group (oinstall):
groupadd -g 200 oinstall

# creating the OSDBA group (dba):
groupadd -g 201 dba

# creating the Oracle software owner user (oracle):
useradd -g oinstall -G dba -m -u 440 oracle
echo -e "oracle\noracle" > /tmp/passwd.dat
passwd oracle < /tmp/passwd.dat

# to detemine whether the nobody user exists, enter the following command:
id nobody

mkdir -p /opt/oracle/product/10.2.0/db_1
chown -R oracle:oinstall /opt/oracle

# because Oracle-10g need redhat-3/redhat-4/SuSE-9, so create a file to
# cheat installer:
echo "redhat-4" > /etc/redhat-release

# configuring kernel parameters:
cat >> /etc/sysctl.conf << "EOF"
# For Oracle
kernel.sem = 250 32000 100 128
kernel.shmmax = 2147483648
fs.file-max = 65536
net.core.rmem_default = 262144
net.core.rmem_max = 262144
net.core.wmem_default = 262144
net.core.wmem_max = 262144
EOF
sysctl -p

# let the user oracle can use X Window:
startx
xhost +

# change to oracle user:
su - oracle

cat > /etc/profile.d/oracle.sh << "EOF"
export ORACLE_HOME=/opt/oracle/product/10.2.0/db_1
export ORACLE_SID=orcl
export TNS_ADMIN=/opt/oracle/tnsadmin
export PATH=$PATH:$ORACLE_HOME/bin:/opt/oracle/client
EOF
source /etc/profile.d/oracle.sh

# 1. Install Oracle:
unzip 10201_database_linux_x86.zip
cd database
./runInstaller

    #################################################################
    # 1). Select Installation Method
    #     [ ] Basic Installation
    #     [x] Advanced Installation
    #
    # 2). Specify Inventory directory and credentials:
    #     inventory directory:/opt/oracle/product/10.2.0/oraInventory
    #     Specify Operating System group name: oinstall
    #
    # 3). Select Installation Type:
    #     [ ] Enterprise Edition
    #     [ ] Standard Edition
    #     [x] Custom
    #     Product Languages: English
    #
    # 4). Specify Home Details
    #     Name: OraDb10g_home1
    #     Path: /opt/oracle/product/10.2.0/db_1
    #
    # 5). Available Product Components:
    #     [x] Oracle Database 10g
    #         [x] Oracle Database 10g
    #	 [ ] Enterprise Edition Options
    #	     [ ] Oracle Advanced Security
    #	     [ ] Oracle Partitioning
    #	     [ ] Oracle Spatial
    #	     [ ] Oracle Label Security
    #	     [ ] Oracle OLAP
    #	     [ ] Data Mining Scoring Engine
    #	 [x] Oracle Net Services
    #	     [x] Oracle Net Listener
    #	     [x] Oracle Connection Manager
    #	 [ ] Oracle Enterprise Manager Console DB
    #	 [x] Oracle Call Interface (OCI)
    #	 [x] Oracle Programmer
    #	 [x] Oracle XML Development Kit
    #	 [ ] iSQL*Plus
    #	 [x] Oracle ODBC Driver
    #
    # 6). Product - Specific Prerequisite Checks
    #     Note: Because BLFS build via source, so the check will 
    #     failed, skip it.
    #
    # 7). Privileged Operating System Groups
    #     Database Administrator (OSDBA) Group: dba
    #     Database Operator (OSOPER) Group: dba
    #
    # 8). Create Database
    #     [ ] Create a dababase
    #     [ ] Configure Automatic Storage Management (ASM)
    #     [x] Install database Software only
    #
    # 9). Install
    #
    # 10). execute the following scripts as root user:
    # /opt/oracle/product/10.2.0/oraInventory/orainstRoot.sh
    # /opt/oracle/product/10.2.0/db_1/root.sh
    #
    # 11). OK
    #################################################################

# Create Database:
dbca

    #################################################################
    # 1). Operations
    #     [x] Create a Database
    #     [ ] Configure Database Options
    #     [ ] Delete a Database
    #     [ ] Manage Templates
    #     [ ] Configure Automatic Storage Management
    #
    # 2). Database Templates
    #     [ ] Custom Database
    #     [ ] Data Warehouse
    #     [x] General Purpose
    #     [ ] Transation Processing
    #
    # 3). Database Identification
    #     Global Database Name: orcl
    #     SID: orcl
    #
    # 4). Management Options
    #
    # 5). Database Credentials
    #     [x] Use the Same Password for All Accounts
    #         Password: secret
    #
    # 6). Storage Options
    #     [x] File System
    #     [ ] Automatic Storage Management (ASM)
    #     [ ] Raw Devices
    #
    # 7). Database File Locations
    #     [x] Use Database File Locations from Template
    #     [ ] Use Common Location for All Database Files
    #     [ ] Use Oracle-Managed Files
    #
    # 8). Recovery Configuration
    #     [ ] Specify Flash Recovery Area
    #     [ ] Enable Archiving
    #
    # 9). Database Content
    #     Sample Schemas:
    #         [x] Sample Schemas
    #
    #     Custorm Scripts:
    #         [x] No scripts to run
    #
    # 10). Initialization Parameters
    #     Memory:
    #         [x] Typical - Allocate memory as a percentage of the 
    #	 total physical memory (500 MB)
    #	 Percentage 44%
    #
    #     Sizing:
    #         Processes: 150
    #
    #     Character Sets:
    #         Database Character Set
    #	     [x] Use the default
    #	     [ ] Use Unicode (AL32UTF8)
    #	     [ ] Choose from the list of character sets
    #         National Character Set: UTF8
    #	 Default Language: American
    #	 Default Data Format: United States
    #
    #     Connection Mode:
    #         [x] Dedicated Server Mode
    #	 [ ] Shared Server Mode
    #
    # 11). Database Storage
    #
    # 12). Creation Options
    #     [x] Create Database
    #     [ ] Save as a Database Template
    #     [ ] Generate Database Creation Scripts
    #
    # 13). Password Management
    #     (Unlock all Account)
    #################################################################

# Create tnsnames.ora:
cat > $TNS_ADMIN/tnsnames.ora << "EOF"
local =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = orcl)
    )
  )
EOF

# check listener:
lsnrctl status

# start listener:
lsnrctl start

# create oracle listener:
netca

    #################################################################
    # 1) Choose the configuration you would like to do:
    #     [x] Listener configuration
    #
    # 2) Select what you want to do:
    #     [x] Add
    #     [ ] Reconfigure
    #     [ ] Delete
    #     [ ] Rename
    #
    # 3). Listener Name
    #     Listener Name: LISTENER
    #
    # 4). Select Protocols
    #     Selected Protocols: TCP
    #
    # 5). TCP/IP Protocol
    #     [x] Use the Standard Port number of 1521
    #     [ ] Use another port number
    #
    # 6). Would you like to configure another listener?
    #     [x] No
    #     [ ] Yes
    #################################################################

# OK, now the installation is finish.

# Start oracle manually:
su - oracle
lsnrctl start
sqlplus / as sysdba
    SQL> startup
    SQL> quit

# Stop oracle manually:
su - oracle
lsnrctl stop
sqlplus / as sysdba
    SQL> shutdown immediate
    SQL> quit

# Create root user:
cat > create_user.sql << "EOF"
-- Create user --
CREATE USER root
	IDENTIFIED BY secret
	DEFAULT TABLESPACE USERS
	TEMPORARY TABLESPACE TEMP;

-- Grant role --
GRANT CONNECT TO root;
GRANT RESOURCE TO root;
GRANT DBA TO root;
GRANT UNLIMITED TABLESPACE TO root WITH ADMIN OPTION;
EOF
sqlplus / as sysdba
    SQL> start create_user.sql

# Connect on Oracle by root user, and create a test table:
cat > create_table.sql << "EOF"
CREATE TABLE test (
	id NUMBER(10) NOT NULL,
	name VARCHAR2(16) NOT NULL
);

INSERT INTO test VALUES (1, 'foo');
INSERT INTO test VALUES (2, 'bar');
COMMIT;
EOF
sqlplus root@local		# Enter password: "secret"
    SQL> start create_table.sql

# Support ODBC:
ln -sfv /opt/oracle/product/10.2.0/db_1/lib/libclntsh.so.10.1 /usr/lib/
ln -sfv libodbcinst.so.2.0.0 /usr/lib/libodbcinst.so.1

cat >> /etc/unixODBC/odbcinst.ini << "EOF"
[Oracle]
Description = Oracle ODBC driver
Driver      = /opt/oracle/product/10.2.0/db_1/lib/libsqora.so.10.1
EOF

cat >> /etc/unixODBC/odbc.ini << "EOF"
[oracle_local]
Driver          = Oracle
Description     = local Oracle database
Database        = orcl
EOF
Servername      = local

isql oracle_local root secret -v
   # +---------------------------------------+
   # | Connected!                            |
   # |                                       |
   # | sql-statement                         |
   # | help [tablename]                      |
   # | quit                                  |
   # |                                       |
   # +---------------------------------------+
   # SQL>
