#!/bin/bash
sudo kill -9 $(ps -A | grep X | awk '{print $1}')
