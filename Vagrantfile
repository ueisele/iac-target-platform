VAGRANTFILE_API_VERSION = "2"

domainname = ENV['DOMAIN_NAME']
publiclb_ip = ENV['PUBLICLB_IP']

cluster = {
  "discovery1" => { :ip => "192.168.17.20", :cpus => 2, :mem => 4092 },
  "discovery2" => { :ip => "192.168.17.21", :cpus => 2, :mem => 4092 },
  "discovery3" => { :ip => "192.168.17.22", :cpus => 2, :mem => 4092 },
  "lb1" => { :ip => "192.168.17.11", :cpus => 2, :mem => 2048 },
  "lb2" => { :ip => "192.168.17.12", :cpus => 2, :mem => 2048 },
  "worker1"    => { :ip => "192.168.17.100", :cpus => 4, :mem => 8192 },
  "worker2"    => { :ip => "192.168.17.101", :cpus => 4, :mem => 8192 },
  "worker3"    => { :ip => "192.168.17.102", :cpus => 4, :mem => 8192 },
  "worker4"    => { :ip => "192.168.17.103", :cpus => 4, :mem => 8192 }
}

groups = {
  "consul-server" => ["discovery1", "discovery2", "discovery3"],
  "consul-agent" => ["lb1", "lb2", "worker1", "worker2", "worker3", "worker4"],
  "consul:children" => ["consul-server", "consul-agent"],
  "public-lb" => ["lb1", "lb2"],
  "zookeeper" => ["discovery1", "discovery2", "discovery3"],
  "mesos-master" => ["discovery1", "discovery2", "discovery3"],
  "mesos-agent" => ["worker1", "worker2", "worker3", "worker4"],
  "mesos:children" => ["mesos-master", "mesos-agent"]
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

  #config.vm.provision :shell, inline: "sed -i \"/^127.0.0.1\\t$(hostname -f)/d\" /etc/hosts"
  config.vm.provision :shell, inline: "bash -c \"echo 127.0.0.1\tlocalhost > /etc/hosts\""
  config.vm.provision :shell, inline: "bash -c \"echo $(hostname -i)\t$(hostname -f) $(hostname) >> /etc/hosts\""
  
  config.vm.provision :ansible do |ansible|
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.galaxy_roles_path = 'provisioning/roles-galaxy'
    ansible.groups = groups   
    ansible.playbook = "provisioning/playbook.yml"
    ansible.extra_vars = {
      domainname: domainname,
      publiclb_ip: publiclb_ip
    }    
  end # end provision

  config.landrush.enabled = true
  config.landrush.tld = domainname
  config.landrush.guest_redirect_dns = true
  config.landrush.host_redirect_dns = false

  config.hostmanager.enabled = false
  config.hostmanager.manage_guest = false
  config.hostmanager.manage_host = false

  config.vbguest.auto_update = false

end
