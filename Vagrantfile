Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

    # Files and Folders
    config.vm.synced_folder "./data", "/data"

  # VM specific configs
  config.vm.provider "virtualbox" do |v|
    v.name = "UMVBox"
    v.gui = false
    v.memory = 8192
    v.cpus = 4

    # USB
    v.customize ["modifyvm", :id, "--usb", "on"]
    # v.customize ["modifyvm", :id, "--usbehci", "on"]  # USB 2.0
    v.customize ["modifyvm", :id, "--usbxhci", "on"]    # USB 3.0
    v.customize ["usbfilter", "add", "0",
      "--target",       :id,
      "--name",         "SECube",
      "--manufacturer", "SECube",
      "--product",      "SECube"]
  end

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

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

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
