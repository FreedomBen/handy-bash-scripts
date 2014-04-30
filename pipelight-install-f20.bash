#!/bin/bash

sudo yum install cabextract
sudo rpm -i http://sourceforge.net/projects/mscorefonts2/files/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

sudo wget http://download.opensuse.org/repositories/home:/DarkPlayer:/Pipelight/Fedora_20/home:DarkPlayer:Pipelight.repo -O /etc/yum.repos.d/pipelight.repo
sudo yum install pipelight && sudo pipelight-plugin --update

sudo pipelight-plugin --enable silverlight
sudo setsebool -P unconfined_mozilla_plugin_transition 0

