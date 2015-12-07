#
# Cookbook Name:: elk_forwarder
# Recipe:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

include_recipe "elk_forwarder::_#{node['elk_forwarder']['install_type']}"
include_recipe 'elk_forwarder::configure'

file '/etc/hosts' do
  content IO.read('/etc/hosts') + "\n192.168.33.10\t_default-logstash.priv.evertrue.com"
  only_if { node['elk_forwarder']['mocking'] }
  not_if { IO.read('/etc/hosts').include? '_default-logstash' }
end
