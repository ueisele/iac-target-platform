#!/usr/bin/env ruby

require 'optparse'

def vagrant_ssh_config_to_hash(vagrant_ssh_config)
    config = {}
    current_host = ""
    vagrant_ssh_config.each_line do |line|
        if line.start_with?("Host")
            current_host = line.split(' ').last
            config[current_host] = {}
        elsif not line.strip.to_s.empty? and not current_host.empty?
            key_value = line.strip.split(' ')
            config[current_host][key_value.first] = key_value.last
        end    
    end
    return config
end

def vagrant_ssh_config_hash_to_ansible_inventory(vagrant_ssh_config_hash)
    inventory = ""
    vagrant_ssh_config_hash.each do |host, entries|
        inventory += "#{host} ansible_host=#{entries['HostName']} ansible_port=#{entries['Port']} ansible_user='#{entries['User']}' ansible_ssh_private_key_file='#{entries['IdentityFile']}'\n"
    end
    return inventory
end    

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: " + File.basename(__FILE__) + " [options]"
  opts.on('-s', '--vagrant-ssh-config FILE', 'Source Vagrant ssh config file') { |v| options[:source] = v }
  opts.on('-o', '--ansible-inventory FILE', 'Output Ansible inventory file') { |v| options[:output] = v }
  opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
end.parse!

vagrant_ssh_config = ""
if options[:source]
    vagrant_ssh_config = File.read(options[:source])
elsif not STDIN.tty? and not STDIN.closed?
    vagrant_ssh_config = STDIN.read
end    

ansible_inventory = vagrant_ssh_config_hash_to_ansible_inventory(vagrant_ssh_config_to_hash(vagrant_ssh_config))

if options[:output]
    File.write(options[:output], ansible_inventory)
else
    puts ansible_inventory
end