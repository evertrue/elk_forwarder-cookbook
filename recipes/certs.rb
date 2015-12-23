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

directory '/etc/pki/tls/certs/logstash-forwarder' do
  recursive true
end

ca_cert = '/etc/pki/tls/certs/logstash-forwarder/ca.pem'

if node['elk_forwarder']['generate_cert']
  openssl_x509 ca_cert do
    common_name node['fqdn']
    org node['elk_forwarder']['ca_cert']['self_signed']['org']
    org_unit node['elk_forwarder']['ca_cert']['self_signed']['org_unit']
    country node['elk_forwarder']['ca_cert']['self_signed']['country']
    expire 30
    if node['elk_forwarder']['ca_cert']['self_signed']['signing_key']
      key_file node['elk_forwarder']['ca_cert']['self_signed']['signing_key']
    end
    notifies :restart, 'service[logstash-forwarder]'
    not_if { ::File.exist? ca_cert } # Necessary because of a bug in openssl_x509
  end
else
  file ca_cert do
    content "#{certs['ca']}\n"
    mode 0644
    notifies :restart, 'service[logstash-forwarder]'
  end
end
