#!/bin/sh

# For now, this script will setup the firewall to deny all incoming traffic except ssh, allow all output traffic, and deny all forwarding traffic.  It will also redirect traffic from port 80 to 8080 so the server can bind as a non-root user
# if you need to delete a rule, list the rules with this:
#    iptables -L INPUT --line-numbers
# then delete the number on the chain you want like this (if deleting rule 2 on the INPUT chain):
#    iptables -D INPUT 2


#
# Flush all current rules from iptables
#
 iptables -F

#
# Allow SSH connections on tcp port 22
# This is essential when working on remote servers via SSH to prevent locking yourself out of the system
#
 iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#
# Set default policies for INPUT, FORWARD and OUTPUT chains
#
 iptables -P INPUT DROP
 iptables -P FORWARD DROP
 iptables -P OUTPUT ACCEPT

#
# Set access for localhost
#
 iptables -A INPUT -i lo -j ACCEPT

#
# Accept packets belonging to established and related connections
#
 iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


# Add NAT rule to redirect traffic for port 80 to port 8080 so web servers don't bind as root
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
# If localhost should be redirected as well:
# iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 8080
# To print out this rule, use this command:
# iptables -t nat --line-numbers -n -L

#
# Save settings
#
# /sbin/service iptables save

# This works for Fedora/CentOS!
iptables-save > /etc/sysconfig/iptables

#
# List rules
#
 iptables -t nat --line-numbers -n -L
 iptables -L -v
