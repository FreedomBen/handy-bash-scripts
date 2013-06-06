#!/bin/bash

# color "\033[1;36m" is light Cyan
echo -e "\n\033[1;36mPartitioning (lsblk):\033[0m"
lsblk

echo -e "\n\033[1;36mDisk Usage (df -h):\033[0m"
df -h

echo -e "\n\033[1;36mInode Usage (df -i):\033[0m"
df -i

echo ""

