# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.7.2"
require 'vagrant-guests-photon'

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "vmware/photon"

  # Enable Docker daemon in remote mode, and forward port to localhost
  # To connect directly to Docker daemon, set local variable DOCKER_HOST to tcp://localhost:2375
  # And unset DOCKER_TLS_VERIFY and DOCKER_CERT_PATH. e.g.:
  #    unset DOCKER_TLS_VERIFY
  #    unset DOCKER_CERT_PATH
  #    export DOCKER_HOST=tcp://localhost:2375
  # Add these lines to your .bashrc/.zshrc for easy & direct access to the Docker VM from your local client.
  config.vm.network :forwarded_port, host: 2375, guest: 2375

  # Synchronize local home directory into Photon VM
  config.vm.synced_folder "~", "/home/vagrant/host"

  # Copy MOTD into Photon VM
  config.vm.provision "file", source: "etc/motd", destination: "/tmp/motd"

  # Add SE aliases to .bashrc and copy MOTD into /etc
  # Start docker daemon in remote access mode
  config.vm.provision :shell, path: "bootstrap.sh"

  # Start the docker daemon in Photon
  config.vm.provision "start docker daemon", type: "shell" do |s|
    s.privileged = true
    s.inline = "systemctl start docker"
  end

  # Build the se_base image upon which the SE images/containers are built
  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se_base", args: "-t='seancummins/se_base'"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se90", args: "-t='se90'"
    d.run "se90",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se90 --name='se90' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se84", args: "-t='se84'"
    d.run "se84",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se84 --name='se84' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se83", args: "-t='se83'"
    d.run "se83",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se83 --name='se83' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se82", args: "-t='se82'"
    d.run "se82",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se82 --name='se82' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se81", args: "-t='se81'"
    d.run "se81",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se81 --name='se81' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se76", args: "-t='se76'"
    d.run "se76",
      cmd: "/bin/bash",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se76 --name='se76' -i -t"
  end


end
