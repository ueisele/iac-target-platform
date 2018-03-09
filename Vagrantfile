VAGRANTFILE_API_VERSION = "2"

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
platform       = YAML.load_file("#{current_dir}/platform.yml").deep_symbolize_keys

domainname = platform[:domain]
publiclbip = platform[:publiclbip]
cluster = platform[:hosts]
groups = platform[:groups]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  cluster.each_with_index do |(hostsymbol, info), index|
    
    hostname = hostsymbol.to_s

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

  config.vm.provision :shell, inline: "bash -c \"echo 127.0.0.1\tlocalhost > /etc/hosts\""
  config.vm.provision :shell, inline: "bash -c \"echo $(hostname -i)\t$(hostname -f) $(hostname) >> /etc/hosts\""
  
  config.vm.provision :ansible do |ansible|
    ansible.galaxy_command = 'ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path}'
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.galaxy_roles_path = 'provisioning/roles-galaxy'
    ansible.groups = groups   
    ansible.playbook = "provisioning/playbook.yml"
    ansible.extra_vars = {
      domainname: domainname,
      publiclbip: publiclbip
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
