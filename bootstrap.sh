#!/usr/bin/env bash

echo "alias se8='docker start se8 && docker attach se8'" >>/home/vagrant/.bashrc
echo "alias se76='docker start se76 && docker attach se76'" >>/home/vagrant/.bashrc
echo "alias se74='docker start se74 && docker attach se74'" >>/home/vagrant/.bashrc
echo "alias ls='ls -Fc --color=tty'" >>/home/vagrant/.bashrc
echo "set -o vi" >>/home/vagrant/.bashrc

sudo mv /tmp/motd /etc

sudo sed -i.bak '/ExecStart/ !b; s/$/ -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/0.0.0.0:2375/' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker
