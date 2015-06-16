#
# Cookbook Name:: elk_forwarder
# Recipe::certs
#
# This is an optional recipe for installing and configuring the ssl settings
# Logstash Forwarder.  It Searches in specified data bag items for the
# ca, cert, and keys.

%w(ca key certificate).each do |c|
  if (!node['elk_forwarder']['certs'] ||
     !node['elk_forwarder']['certs']["#{c}_data_bag"]) ||
     node['elk_forwarder']['mocking']
    node.rm('elk_forwarder', 'config', 'network', "ssl #{c}")
    next
  end

  ssl_thing = data_bag_item(
    node['elk_forwarder']['certs']["#{c}_data_bag"],
    node['elk_forwarder']['certs']["#{c}_data_bag_item"]
  )[node['elk_forwarder']['certs']["#{c}_data_bag_item_key"]]

  directory File.dirname(node['elk_forwarder']['config']['network']["ssl #{c}"]) do
    recursive true
  end

  file node['elk_forwarder']['config']['network']["ssl #{c}"] do
    content ssl_thing
    not_if { ssl_thing.nil? || ssl_thing.empty? }
    notifies :restart, 'service[logstash-forwarder]'
  end
end
