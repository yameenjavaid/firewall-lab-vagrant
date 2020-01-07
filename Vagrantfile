Vagrant.configure("2") do |config|
  config.vm.define "firewall" do |fw|
    fw.vm.box = "ubuntu/xenial64"
    fw.vm.hostname = "firewall"
    fw.vm.network "public_network"
    fw.vm.network "private_network", ip: "192.168.101.10", virtualbox__intnet: "asi1"
    fw.vm.network "private_network", ip: "192.168.102.10", virtualbox__intnet: "asi2"
    fw.vm.network "private_network", ip: "192.168.103.10", virtualbox__intnet: "dpto"
    fw.vm.synced_folder "./fw", "/scripts"
    fw.vm.provider "virtualbox" do |vb|
      vb.name = "Firewall"
      vb.cpus = 1
      vb.memory = "1024"
    end
    fw.vm.provision "shell", path: "./fw/provision-fw.sh"
  end
  config.vm.define "pc01-t1" do |pc01t1|
    pc01t1.vm.box = "peru/ubuntu-18.04-desktop-amd64"
    pc01t1.vm.hostname = "pc01-t1"
    pc01t1.vm.network "private_network", ip: "192.168.101.11", virtualbox__intnet: "asi1"
    config.vm.provider "virtualbox" do |vb|
      vb.name = "pc01-t1"
      vb.gui = true
      vb.cpus = 1
      vb.memory = "1024"
    end
    pc01t1.vm.provision "shell", path: "./t1/provision-t1.sh"
  end
  config.vm.define "pc01-t2" do |pc01t2|
    pc01t2.vm.box = "peru/ubuntu-18.04-desktop-amd64"
    pc01t2.vm.hostname = "pc01-t2"
    pc01t2.vm.network "private_network", ip: "192.168.102.11", virtualbox__intnet: "asi2"
    config.vm.provider "virtualbox" do |vb|
      vb.name = "pc01-t2"
      vb.gui = true
      vb.cpus = 1
      vb.memory = "1024"
    end
    pc01t2.vm.provision "shell", path: "./t2/provision-t2.sh"
  end
  config.vm.define "servus" do |servus|
    servus.vm.box = "ubuntu/xenial64"
    servus.vm.hostname = "servus"
    servus.vm.network "private_network", ip: "192.168.102.100", virtualbox__intnet: "asi2"
    servus.vm.synced_folder "./servus", "/scripts"
    config.vm.provider "virtualbox" do |vb|
      vb.name = "servus"
      vb.gui = false
      vb.cpus = 1
      vb.memory = "1024"
    end
    servus.vm.provision "shell", path: "./servus/provision-servus.sh"
  end
  config.vm.define "pc01-dpto" do |pc01dpto|
    pc01dpto.vm.box = "peru/ubuntu-18.04-desktop-amd64"
    pc01dpto.vm.hostname = "pc01-dpto"
    pc01dpto.vm.network "private_network", ip: "192.168.103.11", virtualbox__intnet: "dpto"
    config.vm.provider "virtualbox" do |vb|
      vb.name = "pc01-dpto"
      vb.gui = true
      vb.cpus = 1
      vb.memory = "1024"
    end
    pc01dpto.vm.provision "shell", path: "./dpto/provision-dpto.sh"
  end
end
