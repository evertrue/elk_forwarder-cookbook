#
# Cookbook Name:: elk_forwarder
# Spec:: default
#
# Copyright (c) 2015 EverTrue, inc., All Rights Reserved.

require 'spec_helper'

describe 'elk_forwarder::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end
    it 'it raises an error with default attributes' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.3 \"").and_return(true)
      expect { chef_run }.to raise_error
    end
  end
  context 'When Certificate Attributes are set, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['elk_forwarder']['config']['network']['ssl certificate'] = '/path'
        node.set['elk_forwarder']['config']['network']['ssl key'] = '/path'
        node.set['elk_forwarder']['config']['network']['ssl ca'] = '/path'
      end
      runner.converge(described_recipe)
    end
    it 'it raises an error with default attributes' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.3 \"").and_return(true)
      chef_run
    end
  end
end
