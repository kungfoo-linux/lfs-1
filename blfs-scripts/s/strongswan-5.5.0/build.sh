#!/bin/bash -e
. ../../blfs.comm

build_src() {
    version=5.5.0
    srcfil=strongswan-$version.tar.bz2
    srcdir=strongswan-$version
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir

    ./configure --prefix=/opt/strongswan-$version \
        --enable-openssl \
        --enable-shared \
        --enable-md4 \
        --enable-eap-mschapv2 \
        --enable-eap-aka \
        --enable-eap-aka-3gpp2 \
        --enable-eap-gtc \
        --enable-eap-identity \
        --enable-eap-md5 \
        --enable-eap-peap \
        --enable-eap-radius \
        --enable-eap-sim \
        --enable-eap-sim-file \
        --enable-eap-simaka-pseudonym \
        --enable-eap-simaka-reauth \
        --enable-eap-simaka-sql \
        --enable-eap-tls \
        --enable-eap-tnc \
        --enable-eap-ttls \
        --enable-xauth-eap \
        --enable-xauth-noauth \
        --disable-static \
        --disable-mysql \
        --disable-ldap
    make $JOBS
    make DESTDIR=$BUILDDIR install

    cp -rfv ../scripts/etc $BUILDDIR/opt/strongswan-$version
    ln -sfTv strongswan-$version $BUILDDIR/opt/strongswan
    
    cleanup_src .. $srcdir
}

configure() {
# strongswan.sh
mkdir -pv $BUILDDIR/etc/profile.d
cat > $BUILDDIR/etc/profile.d/strongswan.sh << "EOF"
export PATH=$PATH:/opt/strongswan/bin:/opt/strongswan/sbin
EOF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: IPsec VPN solution metapackage
 The strongSwan VPN suite is based on the IPsec stack in standard Linux
 kernels. It supports both the IKEv1 and IKEv2 protocols.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='
    i=0
    name=()
    ip=()
    for line in `ip addr | awk -F: '/inet /' | \
        awk '{split($2, a, "/"); print $NF ":" a[1]}'` ; do
    
        name[i]=`echo $line | cut -d ":" -f 1`
        ip[i]=`echo $line | cut -d ":" -f 2`
        let n=$i+1
        echo $n: ${name[$i]} ${ip[$i]}
        let i++
    done
    
    while true ; do
        read -p "choice the network interface(1, ...)" choice
        size=${#name[*]}
        if [ $choice -lt 1 -o $choice -gt $size ] ; then
            echo "choice error."
            continue
        fi

        let n=$choice-1

        read -p "You choice the IP \"${ip[$n]}\", are you sure[y/n]:" choice
        if [ $choice == "y" ] ; then
            break
        fi
    done

    ip=${ip[$n]}
    sed -i "s/VPN-SERVER-ADDRESS/$ip/" /opt/strongswan/etc/strongswan.mobileconfig
	'
}

build
