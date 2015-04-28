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
    it 'converges successfully' do
      stub_command("/usr/local/go/bin/go version | grep \"go1.3 \"").and_return(true)
      chef_run # This should not raise an error
    end
  end
end
