#
# Cookbook Name:: elk_forwarder
# Recipe:: _source
# Author:: Eddie Hurtig <eddie.hurtig@evertrue.com>
#
# Copyright (c) 2015, Parallels IP Holdings GmbH
#

include_recipe 'golang'

directory node['elk_forwarder']['install_dir'] do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode 0700
end

git node['elk_forwarder']['install_dir'] do
  repository node['elk_forwarder']['git_repo']
  revision node['elk_forwarder']['git_ref']
  action :checkout
  notifies :run, 'execute[build-logstash-forwarder]'
end

execute 'build-logstash-forwarder' do
  cwd node['elk_forwarder']['install_dir']
  command '/usr/local/go/bin/go build'
  action :nothing
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
end

template "/etc/init.d/#{node['elk_forwarder']['service_name']}" do
  source 'logstash-forwarder-init.erb'
  owner 'root'
  group 'root'
  mode 0755
end

service node['elk_forwarder']['service_name'] do
  supports status: true, restart: true
  action [:enable, :start]
end
