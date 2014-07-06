#!/bin/bash

### This script is written for Arch Linux ###


echo "This script will configure a good default firewall for an Arch desktop setup"
echo ''
echo 'For more information, see: https://wiki.archlinux.org/index.php/Simple_stateful_firewall'

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup system.  Must be root."
    exit 1
fi

function allowDefaultYes ()
{
    ! [ "$1" = "n" -o "$1" = "N" ]
}

function allowDefaultNo ()
{
    [ "$1" = "y" -o "$1" = "Y" ]
}


sudo pacman -S --needed --noconfirm iptables

# Flush the current setup
iptables -F

# define two new chains called TCP and UDP
iptables -N TCP
iptables -N UDP

# Drop all forwarding packets since we're not using NAT
iptables -P FORWARD DROP

# Accept all outgoing packets
iptables -P OUTPUT ACCEPT

# Default INPUT to drop in case something gets past the rules
iptables -P INPUT DROP

# Allow all traffic belonging to established connections, or new valid traffic related to these connections (such as ICMP error)
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Accept all traffic from loopback interface
iptables -A INPUT -i lo -j ACCEPT

# Drop all traffic of state "INVALID"
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Allow echo requests so people can ping us
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

# Append our UDP and TCP chains
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP


# Be RFC compliant and imitate default linux behavior
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-rst

# Reject all other protocols using ICMP
iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable


# Setup base rules
read -p "Allow SSH? (default Yes) - (Y/N): " SSH
read -p "Allow Avahi/mDNS stuff? (default YES) - (Y/N): " AVAHI
read -p "Allow HTTP? (default No) - (Y/N): " HTTP
read -p "Allow HTTPS? (default No) - (Y/N): " HTTPS
read -p "Allow DNS requests (for server, not avahi/mdns, default No) - (Y/N): " DNS

if $(allowDefaultYes $SSH); then
    iptables -A TCP -p tcp --dport 22 -j ACCEPT
    echo "SSH is allowed"
else
    echo "SSH is not allowed"
fi

if $(allowDefaultYes $AVAHI); then
    iptables -A UDP -p udp -m udp --dport 5353 -j ACCEPT
    echo "AVAHI is allowed"
else
    echo "AVAHI is not allowed"
fi

if $(allowDefaultNo $HTTP); then
    iptables -A TCP -p tcp --dport 80 -j ACCEPT
    echo "HTTP is allowed"
else
    echo "HTTP is not allowed"
fi

if $(allowDefaultNo $HTTPS); then
    iptables -A TCP -p tcp --dport 443 -j ACCEPT
    echo "HTTPS is allowed"
else
    echo "HTTPS is not allowed"
fi

if $(allowDefaultNo $DNS); then
    iptables -A UDP -p udp --dport 53 -j ACCEPT
    echo "DNS is allowed"
else
    echo "DNS is not allowed"
fi

# save off the rules
iptables-save > /etc/iptables/iptables.rules

# start and enable the dameon
systemctl enable iptables.service
systemctl start iptables.service

echo 'Done! (Print rules with iptables -L)'

