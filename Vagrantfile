# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  if File.exist?("config.yml") then
    require "yaml"
    yml = YAML.load_file("config.yml")

    unless File.exist?("tmp/disable_synced_folder")
      if yml.has_key?("synced_folder") then
        synced = yml["synced_folder"]
        synced_host_path = synced.has_key?("host_path") ? synced["host_path"] : "share"
        synced_guest_path = synced.has_key?("guest_path") ? synced["guest_path"] : "/share"
        config.vm.synced_folder synced_host_path, synced_guest_path, create: true
      end
      config.vm.synced_folder "tmp/docker", "/var/lib/docker/tmp", create: true
    end

    if yml.has_key?("virtualbox") then
      vbox = yml["virtualbox"]
      config.vm.provider "virtualbox" do |v|
        v.gui = vbox["gui"] if vbox.has_key?("gui")
        v.memory = vbox["memory"] if vbox.has_key?("memory")
        v.cpus = vbox["cpus"] if vbox.has_key?("cpus")
      end
    end

    if yml.has_key?("proxy") && Vagrant.has_plugin?("vagrant-proxyconf") then
      proxy = yml["proxy"]
      config.proxy.http = proxy["http_proxy"] if proxy.has_key?("http_proxy")
      config.proxy.https = proxy["https_proxy"] if proxy.has_key?("https_proxy")
      config.proxy.no_proxy = proxy["no_proxy"] if proxy.has_key?("no_proxy")
    end
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sed -ie "s/^\\(127.0.0.1 .*\\)$/\\1 $(hostname)/" /etc/hosts && rm /etc/hostse

    apt-get -y update && apt-get -y upgrade
    apt-get -y install gcc make apt-transport-https ca-certificates linux-image-extra-$(uname -r)

    vbga_ver=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
    curl http://download.virtualbox.org/virtualbox/${vbga_ver}/VBoxGuestAdditions_${vbga_ver}.iso -o /tmp/vbga.iso
    mount -t iso9660 /tmp/vbga.iso /mnt/
    /mnt/VBoxLinuxAdditions.run

    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
    apt-cache policy docker-engine
    apt-get -y update && apt-get -y install docker-engine
    systemctl enable docker
    usermod -aG docker ubuntu
  SHELL
end
