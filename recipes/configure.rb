#
# Cookbook Name:: elk_forwarder
# Recipe:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

ruby_block 'Verify that the ssl files exist' do
  block do
    %w(ca cert key).each do |c|
      next if node['elk_forwarder']['mocking']

      file = node['elk_forwarder']['config']['network']["ssl #{c}"]
      if file && !File.exist?(file)
        fail "The ssl #{c} file is configured but does not exist: #{file}"
      end
    end
  end
  action :run
  not_if { node['elk_forwarder']['mocking'] }
end

directory node['elk_forwarder']['config_dir'] do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode '0755'
  action :create
end

ruby_block 'forwarder_attribute_manipulation' do
  block do
    require 'json'
    final = JSON.parse(node['elk_forwarder']['config'].to_json)
    config = JSON.parse(node['elk_forwarder']['config'].to_json)
    final['files'] = []
    config['files'].each do |_key, value|
      final['files'] << value
    end
    node.set['elk_forwarder']['config'] = nil # Wipe it clean
    node.set['elk_forwarder']['config'] = final # set it
    Chef::Log.warn node['elk_forwarder']['config'].to_json
  end
  notifies :create, 'template[Logstash Forwarder Configuration]', :immediately
end

# Generate the config file using the config attribute
template 'Logstash Forwarder Configuration' do
  cookbook 'elk_forwarder'
  path "#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf"
  source 'logstash-forwarder.conf.erb'
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode '0640'
  action :nothing
  notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
end
