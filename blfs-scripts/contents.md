# BLFS (Beyond Linux Scratch) Version 7.6

### Part 1. Post LFS Configuration and Extra Software
#### 1.0. After LFS Configuration Issues
```sh
**  1.0.1. The Bash Shell Startup Files (bash-profile-7.6)
**  1.0.2. /etc/issue (issue-7.6)
**  1.0.3. The /etc/shells File (shells-7.6)
**  1.0.4. Random Number Generation (randomnumber)
**  1.0.5. lsb_release-1.4 (lsb-release-1.4)
```

#### 1.1. Security
```sh
*   1.1.1. Certificate Authority Certificates (CA-7.6)
*   1.1.2. ConsoleKit-0.4.6
*   1.1.3. CrackLib-2.9.1
*   1.1.4. Cyrus SASL-2.1.26 (cyrus-sasl-2.1.26)
*   1.1.5. GnuPG-2.0.26
*   1.1.6. GnuTLS-3.3.7
*   1.1.7. GPGME-1.5.1
*   1.1.8. Haveged-1.9.1
*   1.1.9. Iptables-1.4.21
*   1.1.10. libcap-2.24
*   1.1.11. Linux-PAM-1.1.8
-   1.1.12. MIT Kerberos V5-1.12.2 (krb5-1.12.2)
*   1.1.13. Nettle-2.7.1
*   1.1.14. NSS-3.17
*   1.1.15. OpenSSH-6.6p1
*   1.1.16. OpenSSL-1.0.1i
*   1.1.17. p11-kit-0.20.6
*   1.1.18. Polkit-0.112
*   1.1.19. Shadow-4.2.1
-   1.1.20. ssh-askpass-6.6p1
*   1.1.21. stunnel-5.03
*   1.1.22. Sudo-1.8.10p3
-   1.1.23. Tripwire-2.4.2.2
```

#### 1.2. File Systems and Disk Management
```sh
-   1.2.1. initramfs
**  1.2.2. Fuse-2.9.3
-   1.2.3. jfsutils-1.1.15
-   1.2.4. LVM2-2.02.111
*   1.2.5. mdadm-3.3.2
*   1.2.6. ntfs-3g-2014.2.15
-   1.2.7. gptfdisk-0.8.10
*   1.2.8. parted-3.2
-   1.2.9. reiserfsprogs-3.6.24
**  1.2.10. sshfs-fuse-2.5
-   1.2.11. xfsprogs-3.2.1
*   1.2.12. Other
*   1.2.12.1. dosfstools-3.0.26
```

#### 1.3. Editors
```sh
-   1.3.1. Bluefish-2.2.6
*   1.3.2. Ed-1.10
-   1.3.3. Emacs-24.3
-   1.3.4. JOE-3.7
-   1.3.5. Nano-2.3.6
 *  1.3.6. Vim-7.4
-   1.3.7. Other Editors
```

#### 1.4. Shells
```sh
-   1.4.1. Dash-0.5.7
-   1.4.2. Tcsh-6.18.01
-   1.4.3. zsh-5.0.6
```

#### 1.5. Virtualization
```sh
-   1.5.1. qemu-2.1.0
*   1.5.2. Other
    1.5.2.1. VirtualBox-4.3.26
    1.5.2.2. docker-1.4.1
    1.5.2.3. wine-1.6.2
```

### Part 2. General Libraries and Utilities
#### 2.1. General Libraries
```sh
*   2.1.1. Apr-1.5.1
*   2.1.2. Apr-Util-1.5.3
*   2.1.3. Aspell-0.60.6.1
*   2.1.4. Boost-1.56.0
*   2.1.5. CLucene-2.3.3.4
*   2.1.6. dbus-glib-0.102
*   2.1.7. enchant-1.6.0
*   2.1.8. Exempi-2.2.2
**  2.1.9. GLib-2.40.0
*   2.1.10. GLibmm-2.40.0
*   2.1.11. GMime-2.6.20
*   2.1.12. gobject-introspection-1.40.0
*   2.1.13. Grantlee-0.4.0
*   2.1.14. Gsl-1.16
*   2.1.15. ICU-53.1
*   2.1.16. JS-17.0.0 (JS17-17.0.0)
*   2.1.17. JS-24.2.0 (JS24-24.2.0)
*   2.1.18. JSON-C-0.12
*   2.1.19. JSON-GLib-1.0.2
*   2.1.20. keyutils-1.5.9
*   2.1.21. libarchive-3.1.2
*   2.1.22. libassuan-2.1.2
*   2.1.23. libatasmart-0.19
*   2.1.24. libatomic_ops-7.4.2 (libatomic-ops-7.4.2)
*   2.1.25. libcroco-0.6.8
*   2.1.26. libdaemon-0.14
*   2.1.27. libdbusmenu-qt-0.9.2
*   2.1.28. libESMTP-1.0.6
**  2.1.29. libffi-3.1
*   2.1.30. libgee-0.6.8
*   2.1.31. libgcrypt-1.6.2
*   2.1.32. libgpg-error-1.13
*   2.1.33. libgsf-1.14.30
*   2.1.34. libgusb-0.1.6
*   2.1.35. libical-1.0
**  2.1.36. libidn-1.29
*   2.1.37. libiodbc-3.52.9
*   2.1.38. Libksba-1.3.0
*   2.1.39. liblinear-1.94
*   2.1.40. libpaper-1.1.24
*   2.1.41. libsigc++-2.3.2
*   2.1.42. libsigsegv-2.10
*   2.1.43. libtasn1-4.1
*   2.1.44. libunistring-0.9.4
**  2.1.45. libusb-1.0.19
**  2.1.46. libusb-compat-0.1.5
*   2.1.47. libxml2-2.9.1
*   2.1.48. libxslt-1.1.28
*   2.1.49. libzeitgeist-0.3.18
*   2.1.50. LZO-2.08
*   2.1.51. mtdev-1.1.5
*   2.1.52. NSPR-4.10.7
*   2.1.53. OpenOBEX-1.7.1
**  2.1.54. PCRE-8.35
*   2.1.55. Popt-1.16
*   2.1.56. Pth-2.0.7
*   2.1.57. Ptlib-2.10.10
*   2.1.58. Qca-2.0.3
*   2.1.59. QJson-0.8.1
*   2.1.60. Talloc-2.1.1
*   2.1.61. wv-1.2.9
*   2.1.62. Xapian-1.2.17
*   2.1.63. Other
*   2.1.63.1. libaio-0.3.110
*   2.1.63.2. libedit-3.1.20141030
*   2.1.63.3. protobuf-2.4.1
*   2.1.63.4. protobuf-2.5.0
*   2.1.63.5. Oracle-instant-client-10.2.0.5
    2.1.63.6. apache-log4j-2.1
    2.1.63.7. phantomjs-1.9.8
    2.1.63.8. libmcrypt-2.5.8
```

#### 2.2. Graphics and Font Libraries
```sh
*   2.2.1. AAlib-1.4rc5
*   2.2.2. babl-0.1.10
*   2.2.3. Exiv2-0.24
*   2.2.4. FreeType-2.5.3
*   2.2.5. Fontconfig-2.11.1
*   2.2.6. FriBidi-0.19.6
*   2.2.7. gegl-0.2.0
*   2.2.8. giflib-5.1.0
*   2.2.9. Graphite2-1.2.4
*   2.2.10. Harfbuzz-0.9.35
*   2.2.11. IJS-0.35
*   2.2.12. JasPer-1.900.1
*   2.2.13. Little CMS-1.19 (lcms1-1.19)
*   2.2.14. Little CMS-2.6  (lcms2-2.6)
*   2.2.15. libexif-0.6.21
*   2.2.16. libjpeg-turbo-1.3.1
*   2.2.17. libmng-2.0.2
*   2.2.18. libpng-1.6.13
*   2.2.19. libraw-0.16.0
*   2.2.20. librsvg-2.40.3
*   2.2.21. LibTIFF-4.0.3
*   2.2.22. libwebp-0.4.1
*   2.2.23. newt-0.52.17
*   2.2.24. OpenJPEG-1.5.2
*   2.2.25. Pixman-0.32.6
*   2.2.26. Poppler-0.26.4
*   2.2.27. Qpdf-5.1.2
*   2.2.28. Other
*   2.2.28.1. JBIG-KIT-2.1 (jbigkit-2.1)
*   2.2.28.2. tpp-1.3.1
```

#### 2.3. General Utilities
```sh
*   2.3.1. appdata-tools-0.1.8
*   2.3.2. appstream-glib-0.3.0
*   2.3.3. Compface-1.5.2
*   2.3.4. desktop-file-utils-0.22
    2.3.5. Graphviz-2.38.0
    2.3.6. GTK-Doc-1.20
*   2.3.7. Hd2u-1.0.3
*   2.3.8. hicolor-icon-theme-0.13
    2.3.9. icon-naming-utils-0.8.90
    2.3.10. ImageMagick-6.8.9-7
*   2.3.11. ISO Codes-3.56 (ISO-Codes-3.56)
**  2.3.12. lsof-4.87
    2.3.13. PIN-Entry-0.8.3 (PINEntry-0.8.3)
*   2.3.14. Rarian-0.8.1
    2.3.15. Rep-gtk-0.90.8.1
*   2.3.16. Screen-4.2.1
*   2.3.17. shared-mime-info-1.3
*   2.3.18. Sharutils-4.14
*   2.3.19. HTML Tidy-cvs_20101110 (Tidy-20101110cvs)
*   2.3.20. Time-1.7
*   2.3.21. tree-1.7.0
*   2.3.22. unixODBC-2.3.2
*   2.3.22.1. MySQL-ODBC-driver-5.2.5
*   2.3.22.2. PostgreSQL-ODBC-driver-09.03.0400
-   2.3.22.3. Oracle-ODBC-driver-10.2.0.5
*   2.3.22.4. DB2-ODBC-driver-10.5.0.5
    2.3.23. XScreenSaver-5.30
```

#### 2.4. System Utilities
```sh
*   2.4.1. acpid-2.0.23
    2.4.2. at-3.1.15
    2.4.3. autofs-5.1.0
*   2.4.4. BlueZ-5.23
*   2.4.5. Colord-1.2.3
*   2.4.6. cpio-2.11
*   2.4.7. D-Bus-1.8.8 (DBus-1.8.8)
*   2.4.8. Fcron-3.2.0
*   2.4.9. GPM-1.20.7
    2.4.10. Hdparm-9.43
    2.4.11. Initd-tools-0.1.3
*   2.4.12. lm_sensors-3.3.5 (lm-sensors-3.3.5)
    2.4.13. Logrotate-3.8.7
    2.4.14. MC-4.8.13
    2.4.15. obex-data-server-0.4.6
    2.4.16. p7zip-9.20.1
    2.4.17. Pax-070715
*   2.4.18. pciutils-3.2.1
*   2.4.19. pm-utils-1.4.1
    2.4.20. Raptor-2.0.14
    2.4.21. Rasqal-0.9.32
    2.4.22. Redland-1.0.17
*   2.4.23. sg3_utils-1.39 (sg3-utils-1.39)
*   2.4.24. Strigi-0.7.8
*   2.4.25. Sysstat-11.1.1
*   2.4.26. Udev Extras (Eudev-1.10)
*   2.4.27. UDisks-1.0.5 (UDisks1-1.0.5)
*   2.4.28. UDisks-2.1.3 (UDisks2-2.1.3)
*   2.4.29. UnRar-5.1.7
**  2.4.30. UnZip-6.0
*   2.4.31. UPower-0.9.23
*   2.4.32. usbutils-007
**  2.4.33. Which-2.20
*   2.4.34. Zip-3.0
*   2.4.35. Other
*   2.4.35.1. syslinux-6.03
*   2.4.35.2. cpulimit-2.2
**  2.4.35.3. dpkg-1.16.15
 *  2.4.35.4. apt-0.9.7.9
```

#### 2.5. Programming
```sh
-   2.5.1. Bazaar-2.5.1
*   2.5.2. Check-0.9.14
*   2.5.3. Clisp-2.49
*   2.5.4. CMake-3.0.1
-   2.5.5. CVS-1.11.23
    2.5.6. DejaGnu-1.5.1
    2.5.7. Doxygen-1.8.8
**  2.5.8. elfutils-0.160
*   2.5.9. Expect-5.45
-   2.5.10. GCC-4.9.1
-   2.5.11. GCC-Ada-4.9.1
-   2.5.12. GCC-Java-4.9.1
*   2.5.13. GC-7.4.2
*   2.5.14. GDB-7.8
*   2.5.15. Git-2.1.0
*   2.5.16. Guile-2.0.11
*   2.5.17. Librep-0.92.3
*   2.5.18. LLVM-3.5.0
*   2.5.19. Lua-5.2.3
*   2.5.20. Mercurial-3.1.1
*   2.5.21. NASM-2.11.05
*   2.5.22. NPAPI-SDK-0.27.2
*   2.5.23. Perl Modules
*   2.5.23.1. ExtUtils-Depends-0.402
*   2.5.23.2. ExtUtils-PkgConfig-1.15
*   2.5.23.3. Glib-1.305
*   2.5.23.4. URI-1.65
    2.5.24. PHP-5.6.0
**  2.5.25. Python-2.7.8 (Python2-2.7.8)
*   2.5.26. Python-3.4.1 (Python3-3.4.1)
*   2.5.27. Python Modules
*   2.5.27.1. dbus-python-1.2.0
*   2.5.27.2. Py2cairo-1.10.0
*   2.5.27.3. PyCairo-1.10.0
*   2.5.27.4. PyGObject2-2.28.6
*   2.5.27.5. PyGObject3-3.12.2
*   2.5.28. Ruby-2.1.2
*   2.5.29. SCons-2.3.3
*   2.5.30. S-Lang-2.2.4 (slang-2.2.4)
*   2.5.31. Subversion-1.8.10
*   2.5.32. SWIG-3.0.2
*   2.5.33. Tcl-8.6.2
*   2.5.34. Tk-8.6.2
*   2.5.35. Vala-0.24.0
*   2.5.36. Valgrind-3.10.0
*   2.5.37. yasm-1.3.0
**  2.5.38. apache-ant-1.9.4
**  2.5.39. JUnit-4.11
**  2.5.40. OpenJDK-1.7.0.65/IcedTea-2.5.2 (OpenJDK-1.7.0.65)
*   2.5.41. Other Programming Tools
*   2.5.41.1. strace-4.9
**  2.5.41.2. ctags-5.8
 *  2.5.41.3. cscope-15.8b
*   2.5.41.4. Ruby-1.8.7
*   2.5.41.5. ncurses-ruby-1.3.1
*   2.5.41.6. JDK-6u45
**  2.5.41.7. node.js-0.10.32 (nodejs-0.10.32)
*   2.5.41.8. IASL-20141107
*   2.5.41.9. android-sdk-19
*   2.5.41.10. android-ndk-10d
*   2.5.42.11. eclipse-4.5.0
*   2.5.42.12. Erlang/OTP-17.4 (Erlang-17.4)
*   2.5.42.13. golang-1.4.2
*   2.5.42.14. Scala-2.11.5
**  2.5.42.15. apache-maven-3.0.5
**  2.5.42.16. gradle-2.4
**  2.5.42.17. apache-groovy-2.4.4
    2.5.42.18. mono-4.0.1.28
    2.5.42.19. netbeans-8.0.2
    2.5.42.20. thrift-0.9.2
    2.5.42.21. LuaJIT-2.0.4
    2.5.42.22. re2c-0.16
```

### Part 3. Networking
#### 3.1. Connecting to a Network
```sh
**  3.1.1. dhcpcd-6.4.3
*   3.1.2. DHCP-4.3.1 (DHCP-client-4.3.1 and DHCP-server-4.3.1)
```

#### 3.2. Networking Programs
```sh
    3.2.1. bridge-utils-1.5
    3.2.2. cifs-utils-6.4
    3.2.3. NcFTP-3.2.5
*   3.2.4. Net-tools-CVS_20101030 (Net-tools-20101030cvs)
    3.2.5. NFS-Utils-1.3.0 (nfs-utils-server-1.3.0, nfs-utils-client-1.3.0)
    3.2.6. ntp-4.2.6p5
*   3.2.7. rpcbind-0.2.1
*   3.2.8. rsync-3.1.1
    3.2.9. Samba-4.1.11
**  3.2.10. Wget-1.15
*   3.2.11. Wireless Tools-29 (Wireless-tools-29)
*   3.2.12. wpa_supplicant-2.2 (wpa-supplicant-2.2)
*   3.2.13. Other Networking Programs
```

#### 3.3. Networking Utilities
```sh
*   3.3.1. Avahi-0.6.31
*   3.3.2. BIND Utilities-9.10.0-P2 (bind-utils-9.10.0p2)
*   3.3.3. mod_dnssd-0.6 (mod-dnssd-0.6)
*   3.3.4. NetworkManager-0.9.10.0
*   3.3.5. Nmap-6.47
-   3.3.6. Traceroute-2.0.20
*   3.3.7. Whois-5.2.0
-   3.3.8. Wicd-1.7.2.4
*   3.3.9. Wireshark-1.12.1
*   3.3.10. Other
**  1.3.10.1. tcpdump-4.6.2
*   1.3.10.2. net-snmp-5.7.3
    1.3.10.3. mpssh-1.3.3
    1.3.10.4. tcpreplay-4.1.0
**  1.3.10.5. dpdk-2.0.0
    1.3.10.6. wrk-4.0.2
```

#### 3.4. Networking Libraries
```sh
**  3.4.1. cURL-7.37.1
*   3.4.2. GeoClue-0.12.0
*   3.4.3. glib-networking-2.40.1
*   3.4.4. ldns-1.6.17
*   3.4.5. libevent-2.0.21
*   3.4.6. libnice-0.1.7
**  3.4.7. libnl-3.2.25
**  3.4.8. libpcap-1.6.2
*   3.4.9. libndp-1.4
*   3.4.10. libsoup-2.46.0
*   3.4.11. libtirpc-0.2.5
*   3.4.12. neon-0.30.0
*   3.4.13. Serf-1.3.7
*   3.4.14. Other
*   3.4.14.1. libproxy-0.4.11
*   3.4.14.2. state-threads-1.9
*   3.4.14.3. pjproject-2.3
*   3.4.14.4. netty-4.0.26 (extract to /opt/libs)
*   3.4.14.5. disruptor-3.3.2 (copy to /opt/libs)
    3.4.14.6. zeromq-4.1.4
```

#### 3.5. Text Web Browsers
```sh
-   3.5.1. Links-2.8
*   3.5.2. Lynx-2.8.8rel.2
-   3.5.3. W3m-0.5.3
```

#### 3.6. Mail/News Clients
```sh
    3.6.1. Fetchmail-6.3.26
    3.6.2. mailx-12.4
    3.6.3. Mutt-1.5.23
    3.6.4. Procmail-3.22
    3.6.5. Re-alpine-2.03
*   3.6.6. Other Mail and News Programs
```

### Part 4. Servers
### 4.1. Major Servers
```sh
*   4.1.1. Apache-2.4.10
*   4.1.2. BIND-9.10.0-P2 (bind-9.10.0p2)
-   4.1.3. ProFTPD-1.3.5
*   4.1.4. vsftpd-3.0.2
*   4.1.5. Other
 *  4.1.5.1. nginx-1.8.1
```

#### 4.2. Mail Server Software
```sh
    4.2.1. Dovecot-2.2.13
    4.2.2. Exim-4.84
    4.2.3. Postfix-2.11.1
    4.2.4. sendmail-8.14.9
```

#### 4.3. Databases
```sh
*   4.3.1. Berkeley DB-6.1.19 (BerkeleyDB-6.1.19)
-   4.3.2. MariaDB-10.0.13
*   4.3.3. PostgreSQL-9.3.5
**  4.3.4. SQLite-3.8.6
*   4.3.5. Other
*   4.3.5.1. MySQL-5.1.73
```

#### 4.4. Other Server Software
```sh
    4.4.1. OpenLDAP-2.4.39 (OpenLDAP-client-2.4.39, OpenLDAP-server-2.4.39)
    4.4.2. Unbound-1.4.22
    4.4.3. xinetd-2.3.15
    4.4.4. Other
    4.4.4.1. zookeeper-3.4.6
**  4.4.4.2. kafka-0.8.2.0
    4.4.4.3. redis-3.0.0
    4.4.4.4. memcached-1.4.24
```

### Part 5. X + Window Managers
#### 5.1. X Window System Environment
```sh
*   5.1.1. Xorg Build Environment (Xorg-buildenv-7.7)
*   5.1.2. util-macros-1.19.0
*   5.1.3. Xorg Protocol Headers (Xorg-proto-7.7)
*   5.1.4. libXau-1.0.8
*   5.1.5. libXdmcp-1.1.1
*   5.1.6. xcb-proto-1.11
*   5.1.7. libxcb-1.11
*   5.1.8. Xorg Libraries (Xorg-lib-7.7)
*   5.1.9. xcb-util-0.3.9
*   5.1.10. xcb-util-image-0.3.9
*   5.1.11. xcb-util-keysyms-0.3.9
*   5.1.12. xcb-util-renderutil-0.3.9
*   5.1.13. xcb-util-wm-0.4.1
*   5.1.14. MesaLib-10.2.7
*   5.1.15. xbitmaps-1.1.1
*   5.1.16. Xorg Applications (Xorg-app-7.7)
*   5.1.17. xcursor-themes-1.0.4
*   5.1.18. Xorg Fonts (Xorg-font-7.7)
*   5.1.19. XKeyboardConfig-2.12 (xkeyboard-config-2.12)
*   5.1.20. Xorg-Server-1.16.0
*   5.1.21. Xorg Drivers
*   5.1.21.1. Libevdev-1.2.2
*   5.1.21.2. Xorg Evdev Driver-2.9.0 (Xorg-evdev-2.9.0)
*   5.1.21.3. Xorg ATI Driver-7.4.0 (Xorg-video-ATI-7.4.0)
*   5.1.21.4. libva-1.3.1
*   5.1.21.5. libva-intel-driver-1.3.2
*   5.1.21.6. libvdpau-0.8
*   5.1.22. twm-1.0.8
*   5.1.23. xterm-310
*   5.1.24. xclock-1.0.7
*   5.1.25. xinit-1.3.3
*   5.1.26. Other
*   5.1.26.1. printproto-1.0.5
*   5.1.26.2. libXp-1.0.2
```

#### 5.2. X Libraries
```sh
*   5.2.1. agg-2.5
*   5.2.2. ATK-2.12.0
*   5.2.3. Atkmm-2.22.7
*   5.2.4. at-spi2-core-2.12.0
*   5.2.5. at-spi2-atk-2.12.1
*   5.2.6. Cairo-1.12.16
*   5.2.7. Cairomm-1.10.0
*   5.2.8. Cogl-1.18.2
*   5.2.9. Clutter-1.18.4
*   5.2.10. clutter-gst-2.0.12
*   5.2.11. clutter-gtk-1.4.4
*   5.2.12. FLTK-1.3.2
*   5.2.13. Freeglut-2.8.1
*   5.2.14. gdk-pixbuf-2.30.8
*   5.2.15. GLU-9.0.0
*   5.2.16. GOffice-0.10.17
*   5.2.17. GTK+-2.24.24 (GTK+2-2.24.24)
*   5.2.18. GTK+-3.12.2  (GTK+3-3.12.2)
*   5.2.19. GTK Engines-2.20.2 (GTK-Engines-2.20.2)
*   5.2.20. Gtkmm-2.24.4 (Gtkmm2-2.24.4)
*   5.2.21. Gtkmm-3.12.0 (Gtkmm3-3.12.0)
*   5.2.22. Imlib2-1.4.6
*   5.2.23. libdrm-2.4.56
*   5.2.24. libepoxy-1.2
*   5.2.25. libglade-2.6.4
*   5.2.26. libnotify-0.7.6
*   5.2.27. libxklavier-5.3
*   5.2.28. Pango-1.36.7
*   5.2.29. Pangomm-2.34.0
*   5.2.30. Qt-4.8.6 (Qt4-4.8.6, Qt4-doc-4.8.6)
-   5.2.31. Qt-5.3.1 (Qt5-5.3.1, Qt5-doc-5.3.1)
*   5.2.32. startup-notification-0.12
*   5.2.33. WebKitGTK+-2.4.5 (WebKitGTK3-2.4.5)
*   5.2.34. Other
-   5.2.34.1. WebKitGTK+-2.6.4 (WebKitGTK4-2.6.4)
```

#### 5.3. Window Managers
```sh
*   5.3.1. Fluxbox-1.3.5
*   5.3.2. IceWM-1.3.8
-   5.3.3. openbox-3.5.2
-   5.3.4. sawfish-1.10
*   5.3.5. Other Window Managers
```

### Part 6. Selected GNOME Applications
#### 6.1. GNOME Libraries and Utilities
```sh
*   6.1.1. gsettings-desktop-schemas-3.12.2
*   6.1.2. yelp-xsl-3.12.0
*   6.1.3. GConf-3.2.6
*   6.1.4. libsecret-0.18
*   6.1.5. Gcr-3.12.2
*   6.1.6. gnome-keyring-3.12.2
*   6.1.7. Gvfs-1.20.3
*   6.1.8. Gjs-1.40.1
*   6.1.9. gnome-desktop-3.12.2
*   6.1.10. gnome-video-effects-0.4.1
*   6.1.11. gtksourceview-3.12.3 (gtksourceview3-3.12.3)
*   6.1.12. libgtop-2.30.0
*   6.1.13. libpeas-1.10.1
*   6.1.14. libwnck-3.4.9 (libwnck3-3.4.9)
*   6.1.15. totem-pl-parser-3.10.2
*   6.1.16. VTE-0.36.3 (Vte3-0.36.3)
*   6.1.17. DConf-0.20.0
    6.1.18. gnome-icon-theme-3.12.0
    6.1.19. gnome-icon-theme-extras-3.12.0
    6.1.20. gnome-icon-theme-symbolic-3.12.0
    6.1.21. gnome-themes-standard-3.12.0
    6.1.22. notification-daemon-0.7.6
*   6.1.23. polkit-gnome-0.105
    6.1.24. Yelp-3.12.0
```

#### 6.2. GNOME Applications
```sh
    6.2.1. Baobab-3.12.1
    6.2.2. Brasero-3.10.0
    6.2.3. Cheese-3.12.2
    6.2.4. EOG-3.12.2
    6.2.5. Epiphany-3.12.1
    6.2.6. Evince-3.12.2
    6.2.7. File-Roller-3.12.2
    6.2.8. Gedit-3.12.2
    6.2.9. gnome-calculator-3.12.4
    6.2.10. gnome-nettool-3.8.1
    6.2.11. gnome-screenshot-3.12.0
    6.2.12. gnome-system-monitor-3.12.2
    6.2.13. gnome-terminal-3.12.3
    6.2.14. Gucharmap-3.12.1
    6.2.15. Nautilus-3.12.2
    6.2.16. network-manager-applet-0.9.10.0
    6.2.17. Seahorse-3.12.2
    6.2.18. Totem-3.12.2
```

### Part 7. X Software
#### 7.1. Office Programs
```sh
    7.1.1. AbiWord-3.0.0
    7.1.2. Gnumeric-1.12.17
    7.1.3. LibreOffice-4.3.1
    7.1.4. Other
```

#### 7.2. Graphical Web Browsers
```sh
    7.2.1. SeaMonkey-2.29
*   7.2.2. Firefox-32.0.1
```

#### 7.3. Other X-based Programs
```sh
    7.3.1. Balsa-2.5.1
    7.3.2. Ekiga-4.0.1
    7.3.3. FontForge-2.0.20140101
    7.3.4. Gimp-2.8.14
    7.3.5. gnash-0.8.10
    7.3.6. Gparted-0.19.1
    7.3.7. IcedTea-Web-1.5.1
    7.3.8. Inkscape-0.48.5
    7.3.9. Pidgin-2.10.9
    7.3.10. Rox-Filer-2.11
    7.3.11. rxvt-unicode-9.20
    7.3.12. Thunderbird-31.1.1
    7.3.13. Tigervnc-1.3.1
    7.3.14. Transmission-2.84
    7.3.15. XChat-2.8.8
*   7.3.16. xdg-utils-1.1.0-rc2 (xdg-utils-1.1.0rc2)
```

### Part 8. Multimedia
#### 8.1. Multimedia Libraries and Drivers
```sh
*   8.1.1. alsa-lib-1.0.28
*   8.1.2. alsa-plugins-1.0.28
*   8.1.3. alsa-utils-1.0.28
*   8.1.4. alsa-tools-1.0.28
*   8.1.5. alsa-firmware-1.0.28
*   8.1.6. ALSA OSS-1.0.28 (alsa-oss-1.0.28)
*   8.1.7. AudioFile-0.3.6
*   8.1.8. FAAC-1.28
*   8.1.9. FAAD2-2.7
*   8.1.10. fdk-aac-0.1.3
*   8.1.11. FLAC-1.3.0
*   8.1.12. Grilo-0.2.11
*   8.1.13. Grilo-Plugins-0.2.13
-   8.1.14. GStreamer-0.10.36 (GStreamer0-0.10.36)
-   8.1.15. gst-plugins-base-0.10.36 (gst-plugins-base0-0.10.36)
-   8.1.16. gst-plugins-good-0.10.31 (gst-plugins-good0-0.10.31)
-   8.1.17. gst-plugins-bad-0.10.23  (gst-plugins-bad0-0.10.23)
-   8.1.18. gst-plugins-ugly-0.10.19 (gst-plugins-ugly-0.10.19)
-   8.1.19. gst-ffmpeg-0.10.13       (gst-ffmpeg0-0.10.13)
*   8.1.20. GStreamer-1.4.1 (GStreamer1-1.4.1)
*   8.1.21. gst-plugins-base-1.4.1 (gst-plugins-base1-1.4.1)
*   8.1.22. gst-plugins-good-1.4.1 (gst-plugins-good1-1.4.1)
*   8.1.23. gst-plugins-bad-1.4.1  (gst-plugins-bad1-1.4.1)
*   8.1.24. gst-plugins-ugly-1.4.1 (gst-plugins-ugly1-1.4.1)
*   8.1.25. gst-libav-1.4.1        (gst-libav1-1.4.1)
    8.1.26. IcedTea-Sound-1.0.1
*   8.1.27. Liba52-0.7.4
    8.1.28. Libao-1.2.0
*   8.1.29. libass-0.11.2
*   8.1.30. libcanberra-0.30
    8.1.31. libdiscid-0.6.1
*   8.1.32. libdvdcss-1.3.0
*   8.1.33. Libdvdread-5.0.0
*   8.1.34. Libdvdnav-5.0.1
*   8.1.35. Libdv-1.0.0
*   8.1.36. libmad-0.15.1b
*   8.1.37. libmpeg2-0.5.1
    8.1.38. libmusicbrainz-2.1.5
    8.1.39. libmusicbrainz-5.0.1
*   8.1.40. libogg-1.3.2
    8.1.41. libquicktime-1.2.4
*   8.1.42. libsamplerate-0.1.8
*   8.1.43. libsndfile-1.0.25
*   8.1.44. libtheora-1.1.1
*   8.1.45. libvorbis-1.3.4
*   8.1.46. libvpx-v1.3.0 (libvpx-1.3.0)
    8.1.47. Opal-3.10.10
*   8.1.48. Opus-1.1
*   8.1.49. PulseAudio-5.0
*   8.1.50. SBC-1.2
*   8.1.51. SDL-1.2.15
*   8.1.51.1. SDL-sound-1.0.3
*   8.1.51.2. SDL-image-1.2.12
*   8.1.52. SoundTouch-1.8.0
*   8.1.53. Speex-1.2rc1
*   8.1.54. Taglib-1.9.1
*   8.1.55. x264-20140818-2245 (x264-20140818.2245)
*   8.1.56. xine-lib-1.2.6
*   8.1.57. XviD-1.3.3
*   8.1.58. Other
*   8.1.58.1. PortAudio-19.20140130
*   8.1.58.2. SDL2-2.0.3
*   8.1.58.2.1. SDL2-image-2.0.0
*   8.1.58.3. OpenAL-1.16.0
*   8.1.58.4. libmodplug-0.8.8.5
*   8.1.58.5. live555-2014.11.28
    8.1.58.6. OpenCV-3.0
    8.1.58.7. rtmpdump-2.3
```

#### 8.2. Audio Utilities
```sh
*   8.2.1. Mpg123-1.20.1
    8.2.2. vorbis-tools-1.4.0
*   8.2.3. LAME-3.99.5
    8.2.4. CDParanoia-III-10.2
    8.2.5. FreeTTS-1.2.2
    8.2.6. Audacious-3.5.1
    8.2.7. Amarok-2.8.0
    8.2.8. pnmixer-0.5.1
```

#### 8.3. Video Utilities
```sh
*   8.3.1. FFmpeg-2.3.3
    8.3.2. MPlayer-1.1.1
    8.3.3. Transcode-1.1.7
*   8.3.4. VLC-2.1.5
    8.3.5. xine-ui-0.99.9
```

#### 8.4. CD/DVD-Writing Utilities
```sh
    8.4.1. Cdrdao-1.2.3
    8.4.2. dvd+rw-tools-7.1
    8.4.3. K3b-2.0.2
*   8.4.4. libburn-1.3.8
*   8.4.5. libisoburn-1.3.8
*   8.4.6. libisofs-1.3.8
    8.4.7. SimpleBurn-1.6.5
*   8.4.8. Other
*   8.4.8.1. cdrtools-3.00
```

### Part 9. Printing, Scanning and Typesetting
#### 9.1. Printing
```sh
*   9.1.1. Cups-1.7.5
    9.1.2. cups-filters-1.0.58
*   9.1.3. ghostscript-9.14
    9.1.4. Gutenprint-5.2.10
```

#### 9.2. Scanning
```sh
    9.2.1. SANE-1.0.24
    9.2.2. XSane-0.999
```

#### 9.3. Standard Generalized Markup Language (SGML)
```sh
    9.3.1. sgml-common-0.6.3
    9.3.2. docbook-3.1 (docbook3-3.1)
    9.3.3. docbook-4.5 (docbook4-4.5)
    9.3.4. OpenSP-1.5.2
    9.3.5. OpenJade-1.3.2
    9.3.6. docbook-dsssl-1.79
    9.3.7. DocBook-utils-0.6.14
```

#### 9.4. Extensible Markup Language (XML)
```sh
*   9.4.1. docbook-xml-4.5
*   9.4.2. docbook-xsl-1.78.1
*   9.4.3. Itstool-2.0.2
*   9.4.4. xmlto-0.0.26
```

#### 9.5. PostScript
```sh
    9.5.1. a2ps-4.14
*   9.5.2. Enscript-1.6.6
    9.5.3. PSUtils-p17
*   9.5.4. ePDFView-0.1.8
*   9.5.5. fop-1.1
*   9.5.6. paps-0.6.8
```

#### 9.6. Typesetting
```sh
    9.6.1. install-tl-unx
    9.6.2. texlive-20140525
    9.6.3. biblatex-biber-1.8
*   9.6.4. Other
    9.6.4.1. dblatex-0.3.5
```

### Part 10. Xfce
#### 10.1. Xfce Desktop
```sh
*   10.1.1. libxfce4util-4.10.1
*   10.1.2. Xfconf-4.10.0
*   10.1.3. libxfce4ui-4.10.0
*   10.1.4. Exo-0.10.2
*   10.1.5. Garcon-0.3.0
*   10.1.6. gtk-xfce-engine-3.0.1
*   10.1.7. libwnck-2.30.7 (libwnck2-2.30.7)
*   10.1.8. libxfcegui4-4.10.0
*   10.1.9. xfce4-panel-4.10.1
*   10.1.10. Thunar-1.6.3
*   10.1.11. thunar-volman-0.8.0
*   10.1.12. Tumbler-0.1.30
*   10.1.13. xfce4-appfinder-4.10.1
*   10.1.14. xfce4-power-manager-1.4.0
*   10.1.15. xfce4-settings-4.10.1
*   10.1.16. Xfdesktop-4.10.2
*   10.1.17. Xfwm4-4.10.1
*   10.1.18. xfce4-session-4.10.1
```

#### 10.2. Xfce Applications
```sh
-   10.2.1. Midori-0.5.8
-   10.2.2. Parole-0.5.4
-   10.2.3. gtksourceview-2.10.5 (gtksourceview2-2.10.5)
-   10.2.4. Mousepad-0.3.0
*   10.2.5. Vte-0.28.2 (Vte2-0.28.2)
*   10.2.6. xfce4-terminal-0.6.3
-   10.2.7. Xfburn-0.5.2
-   10.2.8. Ristretto-0.6.3
-   10.2.9. libunique-1.1.6
-   10.2.10. xfce4-mixer-4.10.0
-   10.2.11. xfce4-notifyd-0.2.4
```

### Part 11. KDE
#### 11.1. The KDE Core
```sh
*   11.1.1. KDE Pre-installation Configuration (KDE-cfg-7.6)
*   11.1.2. Automoc4-0.9.88
*   11.1.3. Phonon-4.8.0
*   11.1.4. Phonon-backend-gstreamer-4.8.0
*   11.1.5. Phonon-backend-vlc-0.8.0
*   11.1.6. Akonadi-1.13.0
*   11.1.7. Attica-0.4.2
*   11.1.8. QImageblitz-0.0.6
*   11.1.9. Polkit-Qt-0.112.0
*   11.1.10. Oxygen-icons-4.14.1
*   11.1.11. Kdelibs-4.14.1
*   11.1.12. Kfilemetadata-4.14.1
*   11.1.13. Kdepimlibs-4.14.1
*   11.1.14. Baloo-4.14.1
*   11.1.15. Baloo-widgets-4.14.1
*   11.1.16. Polkit-kde-agent-0.99.0
*   11.1.17. Kactivities-4.13.3
*   11.1.18. Kde-runtime-4.14.1
*   11.1.19. Kde-baseapps-4.14.1
*   11.1.20. Kde-base-artwork-4.14.1
*   11.1.21. Kde-workspace-4.11.12
```

#### 11.2. KDE Additional Packages
```sh
*   11.2.1. Konsole-4.14.1
*   11.2.2. Kate-4.14.1
    11.2.3. Ark-4.14.1
    11.2.4. Kmix-4.14.1
    11.2.5. libkcddb-4.14.1
    11.2.6. Kdepim-runtime-4.14.1
    11.2.7. Kdepim-4.14.1
    11.2.8. libkexiv2-4.14.1
    11.2.9. Kdeplasma-addons-4.14.1
    11.2.10. Okular-4.14.1
    11.2.11. libkdcraw-4.14.1
    11.2.12. Gwenview-4.14.1
    11.2.13. Further KDE packages
```

### Part 12. Big data and Cloud Computer
#### 12.1. Big data and Cloud Computer
```sh
*   12.1.1. Hadoop-2.6.0
    12.1.2. apache-stome-0.9.4
    12.1.3. Spark-1.3.0
```
