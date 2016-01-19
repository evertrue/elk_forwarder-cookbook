#
# Cookbook Name:: elk_forwarder
# Recipe::certs
#
# This is an optional recipe for installing and configuring the ssl settings
# Logstash Forwarder.  It Searches in specified data bag items for the
# ca, cert, and keys.

certs = data_bag_item(
  node['elk_forwarder']['cert_data_bag'],
  node['elk_forwarder']['cert_data_bag_item']
)['data']

ssl_files_to_process = %w(ca)

if node['elk_forwarder']['config']['network']['ssl certificate']
  ssl_files_to_process += %w(certificate key)
end

ssl_files_to_process.each do |c|
  directory File.dirname(node['elk_forwarder']['config']['network']["ssl #{c}"]) do
    recursive true
  end

  file node['elk_forwarder']['config']['network']["ssl #{c}"] do
    content certs[c]
    mode '600'
    notifies :restart, 'service[logstash-forwarder]'
  end
end
