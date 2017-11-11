VAGRANTFILE_API_VERSION = "2"

domainname = "platform.novatec"

cluster = {
  "lb1" => { :ip => "192.168.17.10", :cpus => 2, :mem => 2048 },
  "lb2" => { :ip => "192.168.17.11", :cpus => 2, :mem => 2048 },
  "discovery1" => { :ip => "192.168.17.20", :cpus => 2, :mem => 2048 },
  "discovery2" => { :ip => "192.168.17.21", :cpus => 2, :mem => 2048 },
  "discovery3" => { :ip => "192.168.17.22", :cpus => 2, :mem => 2048 },
  "worker1"    => { :ip => "192.168.17.100", :cpus => 4, :mem => 6144 },
  "worker2"    => { :ip => "192.168.17.101", :cpus => 4, :mem => 6144 }
}

groups = {
  "public-lb" => ["lb1", "lb2"],
  "public-dns" => ["lb1", "lb2"],
  "zookeeper" => ["discovery1", "discovery2", "discovery3"],
  "consul-server" => ["discovery1", "discovery2", "discovery3"],
  "consul-agent" => ["lb1", "lb2", "worker1", "worker2"]
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  cluster.each_with_index do |(hostname, info), index|

    config.vm.define hostname do |cfg|
      cfg.vm.hostname = hostname + "." + domainname
      cfg.vm.box = "debian/contrib-stretch64"
      
      cfg.vm.network :private_network, ip: info[:ip]

      cfg.vm.provider :virtualbox do |vb|
        vb.linked_clone = true
        vb.name = domainname + "_" + hostname
        vb.cpus = info[:cpus]
        vb.memory = info[:mem]
        vb.customize ["modifyvm", :id, "--ostype", "Debian_64"]
        vb.customize ["modifyvm", :id, "--pagefusion", "on"]
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      end # end provider

    end # end config
    
  end # end cluster

  config.vm.provision :shell, inline: "sed -i \"/^127.0.0.1\\t$(hostname -f)/d\" /etc/hosts"

  config.vm.provision :ansible do |ansible|
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.galaxy_roles_path = 'provisioning/roles-galaxy'
    ansible.groups = groups   
    ansible.playbook = "provisioning/playbook.yml"
  end # end provision

  config.landrush.enabled = true
  config.landrush.tld = domainname
  config.landrush.guest_redirect_dns = true
  config.landrush.host_redirect_dns = false

  config.hostmanager.enabled = false
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = false

  config.vbguest.auto_update = false

end
