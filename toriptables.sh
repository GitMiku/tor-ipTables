#!/bin/sh
### BEGIN INIT INFO
# Provides:          toriptables.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

# I learned this from https://wiki.torproject.org/noreply/TheOnionRouter/Transp$

#Reject all ICMP packets because they have no owner which creates a leak
iptables -A OUTPUT -p icmp -j REJECT

#All traffic for the user root will go through tor
iptables -t nat -A OUTPUT ! -o lo -p tcp -m owner --uid-owner root -m tcp -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT ! -o lo -p udp -m owner --uid-owner root -m udp --dport 53 -j REDIRECT --to-ports 53
iptables -t filter -A OUTPUT -p tcp -m owner --uid-owner root -m tcp --dport 9040 -j ACCEPT
iptables -t filter -A OUTPUT -p udp -m owner --uid-owner root -m udp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT ! -o lo -m owner --uid-owner root -j DROP

#All traffic through your user will go through tor
iptables -t nat -A OUTPUT ! -o lo -p tcp -m owner --uid-owner YOURUSER -m tcp -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT ! -o lo -p udp -m owner --uid-owner YOURUSER -m udp --dport 53 -j REDIRECT --to-ports 53
iptables -t filter -A OUTPUT -p tcp -m owner --uid-owner YOURUSER -m tcp --dport 9040 -j ACCEPT
iptables -t filter -A OUTPUT -p udp -m owner --uid-owner YOURUSER -m udp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT ! -o lo -m owner --uid-owner YOURUSER -j DROP
