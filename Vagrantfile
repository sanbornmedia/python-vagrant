Vagrant.configure("2") do |config|
	
	# Specify the base box
	config.vm.box = "primalskill/ubuntu-trusty64"
	
	# Setup port forwarding
	config.vm.network :forwarded_port, guest: 80, host: 8000, auto_correct: true
	config.vm.network :forwarded_port, guest: 3306, host: 3306, auto_correct: true
	config.vm.network :forwarded_port, guest: 8001, host: 8001, auto_correct: true

    # Setup synced folder
    config.vm.synced_folder "./", "/var/www", create: true, group: "www-data", owner: "www-data"

    # VM specific configs
    config.vm.provider "virtualbox" do |v|
    	v.name = "Python Vagrant"
    	v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    # Shell provisioning
    config.vm.provision "shell" do |s|
    	s.path = "provision/setup.sh"
    end
end
