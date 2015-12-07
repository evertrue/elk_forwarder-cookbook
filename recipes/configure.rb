#
# Cookbook Name:: elk_forwarder
# Recipe:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

directory node['elk_forwarder']['config_dir'] do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode 0755
  action :create
end

# Generate the config file using the config attribute
file "#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf" do
  user node['elk_forwarder']['user']
  group node['elk_forwarder']['group']
  mode 0644
  content(
    lazy do
      JSON.pretty_generate(
        node['elk_forwarder']['config'].merge(
          'files' =>
            node['elk_forwarder']['config']['files'].each_with_object([]) do |(_key, value), m|
              m << value
            end
        )
      ) + "\n"
    end
  )
  notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
end
