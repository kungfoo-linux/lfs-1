#!/bin/bash

iptables -A INPUT -p udp --dport 500 -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.99.0.0/16 -o eth0 -j MASQUERADE
iptables -A FORWARD -s 10.99.0.0/16 -j ACCEPT
