#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

def flatten(current_key, current_hash, flat)
    current_hash.each do |key, value|
        actual_key = !current_key ? key : "#{current_key}:#{key}"
        if value.is_a?(Hash)
            flatten(actual_key, value, flat)
        else
            if not flat.has_key?(actual_key)
                flat[actual_key] = []
            end
            if value.is_a?(Array)
                flat[actual_key].push(*value)
            else
                flat[actual_key].push(value)
            end
        end    
    end
end

def hash_to_ini(hash)
    result = ""
    hash.each do |key, value|
        result += "[#{key}]\n"
        value.each do |element|
            if element.is_a?(Hash)
                element.each do |element_key, element_value|
                    result += "#{element_key}=#{element_value}\n"
                end
            else
                result += "#{element}\n"
            end
        end
        result += "\n"
    end
    return result
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: " + File.basename(__FILE__) + " [options]"
  opts.on('-s', '--source-yaml FILE', 'Source yaml file') { |v| options[:source] = v }
  opts.on('-o', '--output-ini FILE', 'Output ini file') { |v| options[:output] = v }
  opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
end.parse!

yaml = {}
if options[:source]
    yaml = YAML.load_file(options[:source])
elsif not STDIN.tty? and not STDIN.closed?
    yaml = YAML.load(STDIN.read)
end    

flat = {}
flatten(nil, yaml, flat)
ini = hash_to_ini(flat)

if options[:output]
    File.write(options[:output], ini)
else
    puts ini
end