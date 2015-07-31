# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
#  config.vm.box = "vmware/photon"

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
    s.inline = "sudo apt-get update -y"
  end

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.network :forwarded_port, host: 4567, guest: 2376
  config.vm.synced_folder "~", "/home/vagrant/host"

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se_base", args: "-t='se_base'"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se8", args: "-t='se8'"
    d.run "se8",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se8 --name='se8' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se76", args: "-t='se76'"
    d.run "se76",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se76 --name='se76' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se74", args: "-t='se74'"
    d.run "se74",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h dockerized_se74 --name='se74' -i -t"
  end

end
