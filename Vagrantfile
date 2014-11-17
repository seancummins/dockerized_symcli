# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network :forwarded_port, host: 4567, guest: 2376
  config.vm.synced_folder "~", "/home/vagrant/host"

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se8", args: "-t='se8'"
    d.run "se8",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h se8 --name='se8' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se76", args: "-t='se76'"
    d.run "se76",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h se76 --name='se76' -i -t"
  end

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant/se74", args: "-t='se74'"
    d.run "se74",
      cmd: "/bin/zsh",
      args: "-v /home/vagrant/host:/root -w /root -h se74 --name='se74' -i -t"
  end

end

