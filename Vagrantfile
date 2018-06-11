Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network :private_network, ip: '192.168.33.11'
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3366

  config.vm.provision "shell", inline: 'echo "Vagrant Provision: network configuration => $(/bin/date +%T)"'
  #config.vm.provision "shell", inline: 'grep "^127.0.0.1 $(/usr/bin/lsb_release -sc)\$" --silent /etc/hosts || echo "127.0.0.1 $(/usr/bin/lsb_release -sc)" >> /etc/hosts'

  #readmore config file
  config.vm.provision "shell", inline: 'echo "#### read other config file"'
  config.vm.synced_folder "data/www", "/var/www/html", owner: "vagrant", group: "vagrant"
  # config.vm.synced_folder "etc/vhosts", "/etc/apache2/sites-available"
  #if File.exist? "Vagrantfile.local"
  #  instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local"
  #end
  #config.vm.provision "shell", inline: "usermod -a -G admin vagrant"
  #config.vm.provision "shell", inline: "usermod -a -G www-data vagrant"

  config.vm.provision "shell", path: "Vagrant.bootstrap.sh"
  config.vm.provision "shell", path: "config_mysql.sh"
 end
