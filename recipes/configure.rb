#
# Cookbook Name:: elk_forwarder
# Recipe:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

ruby_block 'Verify that the ssl files exist' do
  block do
    %w(ca cert key).each do |c|
      file = node['elk_forwarder']['config']['network']["ssl #{c}"]
      if file && !File.exist?(file)
        fail "The ssl #{c} file is configured but does not exist: #{file}"
      end
    end
  end
  action :run
end

directory node['elk_forwarder']['config_dir'] do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode '0755'
  action :create
end

file "#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf" do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode '0640'
  content JSON.pretty_generate(node['elk_forwarder']['config'])
  notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
end
