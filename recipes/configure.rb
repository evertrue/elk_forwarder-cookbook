
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
  content node['elk_forwarder']['config'].to_json
  notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
end
