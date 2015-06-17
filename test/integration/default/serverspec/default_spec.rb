require 'spec_helper'

describe 'It installs logstash-forwarder' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe file('/opt/logstash-forwarder/bin/logstash-forwarder') do
    it { is_expected.to be_file }
    it { is_expected.to be_executable }
  end

  describe file '/etc/logstash-forwarder/logstash-forwarder.conf' do
    it { is_expected.to be_file }
    its(:content) { is_expected.to include '"ssl ca":' }
    its(:content) { is_expected.to include '/etc/pki/tls/certs/logstash-forwarder/ca.pem' }
    its(:content) { is_expected.to include '/var/log/syslog' }
  end

  describe file '/var/log/logstash-forwarder/logstash-forwarder.log' do
    it { is_expected.to be_file }
  end

  describe file '/etc/pki/tls/certs/logstash-forwarder/ca.pem' do
    it { is_expected.to be_file }
    its(:content) { is_expected.to include 'MIIHSzCCBTOgAwIBAgIJAOs1IogcrEX7MA0GCSq' }
  end

  describe service('logstash-forwarder') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
end
