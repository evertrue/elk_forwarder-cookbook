#
# Cookbook Name:: elk_forwarder
# Recipe:: _source
# Author:: Eddie Hurtig <eddie.hurtig@evertrue.com>
#
# Copyright (c) 2015, Parallels IP Holdings GmbH
#

include_recipe 'golang'

# Enture that our install and build directories exist
directory "#{node['elk_forwarder']['install_dir']}/bin" do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode 0700
  recursive true
end

directory node['elk_forwarder']['build_dir'] do
  recursive true
end

git node['elk_forwarder']['build_dir'] do
  repository node['elk_forwarder']['git_repo']
  revision node['elk_forwarder']['git_ref']
  action :checkout
  notifies :run, 'execute[build-logstash-forwarder]', :immediately
end

# Build the logstash forwarder
execute 'build-logstash-forwarder' do
  cwd node['elk_forwarder']['build_dir']
  command '/usr/local/go/bin/go build -o logstash-forwarder'
  action :nothing
end

# Install the actual binary
remote_file 'Copy logstash-forwarder binary' do
  path "#{node['elk_forwarder']['install_dir']}/bin/logstash-forwarder"
  source "file://#{node['elk_forwarder']['build_dir']}/logstash-forwarder"
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode 0755
end

# Add the service file
template "/etc/init.d/#{node['elk_forwarder']['service_name']}" do
  source 'logstash-forwarder-init.erb'
  owner 'root'
  group 'root'
  mode 0755
end

# Enable and start the service
service node['elk_forwarder']['service_name'] do
  supports status: true, restart: true
  action [:enable, :start]
end
