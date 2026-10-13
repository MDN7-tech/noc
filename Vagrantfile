Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-12"
  config.vm.box_check_update = false
  config.vm.hostname = "vh-test-01"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/vagrant.yml"
  end
end
