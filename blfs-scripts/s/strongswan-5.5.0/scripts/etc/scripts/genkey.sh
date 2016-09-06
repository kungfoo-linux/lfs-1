#!/bin/bash

IPSEC_BIN=ipsec
IPSECD=/opt/strongswan/etc/ipsec.d
IP=119.28.55.176
O="BAT-XG-01"
CN="BAT-CA"

# generate a new private key:
$IPSEC_BIN pki --gen --type rsa --size 4096 --outform der > $IPSECD/private/strongswanKey.der
chmod 600 $IPSECD/private/strongswanKey.der

# create a self signed certificate:
$IPSEC_BIN pki --self --ca --lifetime 3650 --in $IPSECD/private/strongswanKey.der \
    --type rsa --dn "C=NL, O=$O, CN=$CN" --outform der > $IPSECD/cacerts/strongswanCert.der

$IPSEC_BIN pki --gen --type rsa --size 2048 --outform der > $IPSECD/private/vpnHostKey.der
chmod 600 $IPSECD/private/vpnHostKey.der

# extract the public key from a private key/certificate:
$IPSEC_BIN pki --pub --in $IPSECD/private/vpnHostKey.der --type rsa | $IPSEC_BIN pki \
    --issue --lifetime 730 --cacert $IPSECD/cacerts/strongswanCert.der \
    --cakey $IPSECD/private/strongswanKey.der --dn "C=NL, O=$O, CN=$CN" \
    --san $IP --san $IP --san $IP  --san @$IP --flag serverAuth --flag ikeIntermediate --outform der \
    > $IPSECD/certs/vpnHostCert.der

$IPSEC_BIN pki --gen --type rsa --size 2048 --outform der > $IPSECD/private/JohnKey.der
chmod 600 $IPSECD/private/JohnKey.der

$IPSEC_BIN pki --pub --in $IPSECD/private/JohnKey.der --type rsa | $IPSEC_BIN pki --issue --lifetime 730 \
    --cacert $IPSECD/cacerts/strongswanCert.der --cakey $IPSECD/private/strongswanKey.der \
    --san "john@$IP" \
    --outform der > $IPSECD/certs/JohnCert.der

openssl rsa -inform DER -in $IPSECD/private/JohnKey.der -out $IPSECD/private/JohnKey.pem -outform PEM
openssl x509 -inform DER -in $IPSECD/certs/JohnCert.der -out $IPSECD/certs/JohnCert.pem -outform PEM
openssl x509 -inform DER -in $IPSECD/cacerts/strongswanCert.der -out $IPSECD/cacerts/strongswanCert.pem -outform PEM
openssl pkcs12 -export -inkey $IPSECD/private/JohnKey.pem -in $IPSECD/certs/JohnCert.pem \
    -name "BAT VPN"  -certfile $IPSECD/cacerts/strongswanCert.pem -caname "$CA" -out $IPSECD/John.p12
