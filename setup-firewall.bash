#!/bin/sh

# For now, this script will setup the firewall to deny all incoming traffic except ssh, allow all output traffic, and deny all forwarding traffic

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

#
# Save settings
#
 /sbin/service iptables save

#
# List rules
#
 iptables -L -v
