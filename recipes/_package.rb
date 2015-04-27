
remote_file node['elk_forwarder']['package_path'] do
  source node['elk_forwarder']['package_source']
end

if platform_family?('ubuntu', 'debian')
  dpkg_package 'logstash-forwarder' do
    source node['elk_forwarder']['package_path']
    action :install
  end
else
  package 'logstash-forwarder' do
    source node['elk_forwarder']['package_path']
    action :install
  end
end

service node['elk_forwarder']['service_name'] do
  supports status: true, restart: true, reload: true
  action [:start, :enable]
end
