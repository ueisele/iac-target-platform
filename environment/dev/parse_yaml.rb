#!/usr/bin/env ruby

require 'optparse'
require 'yaml'

def value_at_path(element, path = "")
    return path.split(".").inject(element) { |current_element, key| current_element.is_a?(Hash) ? current_element[key] : current_element[key.to_i] }
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: " + File.basename(__FILE__) + " [options]"
  opts.on('-f', '--file FILE', 'Yaml file') { |v| options[:file] = v }
  opts.on('-p', '--path PATH', 'Path in yaml') { |v| options[:path] = v }
  opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
end.parse!

yaml = {}
if options[:file]
    yaml = YAML.load_file(options[:file])
elsif not STDIN.tty? and not STDIN.closed?
    yaml = YAML.load(STDIN.read)
end     

path = ""
if options[:path]
    path = options[:path]
end

value = value_at_path(yaml, path)
puts value.is_a?(Hash) ? value.to_yaml : value