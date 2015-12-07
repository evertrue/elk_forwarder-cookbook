default['elk_forwarder']['cert_data_bag']      = 'certificates'
default['elk_forwarder']['cert_data_bag_item'] = 'logstash'
default['elk_forwarder']['ca_cert']['self_signed'] = {
  'org' => 'Log Server Self Signed',
  'org_unit' => '.',
  'country' => 'US'
}
