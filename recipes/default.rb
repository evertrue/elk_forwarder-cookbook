#
# Cookbook Name:: elk_forwarder
# Recipe:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

case node['elk_forwarder']['install_type']
when 'package'
  include_recipe 'elk_forwarder::_package'
when 'source'
  include_recipe 'elk_forwarder::_source'
end

include_recipe 'elk_forwarder::configure'
