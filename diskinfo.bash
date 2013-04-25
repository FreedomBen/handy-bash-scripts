#!/bin/bash

# color "\033[1;36m" is light Cyan
echo -e "\n\033[1;36mPartitioning (lsblk):\033[0m"
lsblk

echo -e "\n\033[1;36mUsage (df -h):\033[0m"
df -h

echo ""
