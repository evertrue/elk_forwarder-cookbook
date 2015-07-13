# elk_forwarder [![Build Status](https://travis-ci.org/evertrue/elk_forwarder-cookbook.svg)](https://travis-ci.org/evertrue/elk_forwarder-cookbook) [![Dependency Status](https://gemnasium.com/evertrue/elk_forwarder-cookbook.svg)](https://gemnasium.com/evertrue/elk_forwarder-cookbook)

Installs and configures the [logstash-forwarder](https://github.com/elastic/logstash-forwarder) to forward specified logs to specified servers

# Requirements

* `golang` cookbook

# Attributes

You can also find comments in [attributes/default.rb](https://github.com/evertrue/elk_forwarder-cookbook/blob/master/attributes/default.rb)

## General Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['install_type']</tt></td>
    <td>String</td>
    <td>source or package</td>
    <td><tt>package</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['config_dir']</tt></td>
    <td>String</td>
    <td>Where to put config</td>
    <td><tt>/etc/logstash-forwarder</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['service_name']</tt></td>
    <td>String</td>
    <td>The Service Name</td>
    <td><tt>logstash-forwarder</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['log_dir']</tt></td>
    <td>String</td>
    <td>Directory to log to</td>
    <td><tt>/var/log/logstash-forwarder</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['install_dir']</tt></td>
    <td>String</td>
    <td>Directory to install to</td>
    <td><tt>/opt/logstash-forwarder</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['daemon_args']</tt></td>
    <td>String</td>
    <td>Extra args for the forwarder</td>
    <td><tt>-spool-size 5</tt></td>
  </tr>
  <tr>
    <td><tt>['elk_forwarder']['syslog']['facility']</tt></td>
    <td>String</td>
    <td>The Syslog facility.</td>
    <td><tt>local0</tt></td>
  </tr>
</table>

## Config File Attributes

The `node['elk_forwarder']['config']` hash closely mimics the logstash forwarder config file format, with the only difference of the `files` key contains a hash instead of an array

The following table is namespaced under `node['elk_forwarder']['config']` so prepend `node['elk_forwarder']['config']` to the key column
<table>
  <tr>
    <td><tt>['network']['servers']</tt></td>
    <td>Array</td>
    <td>An array of logstash agent address:port values</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['network']['ssl certificate']</tt></td>
    <td>String</td>
    <td>The path to find the SSL Certificate</td>
    <td>/etc/pki/tls/certs/logstash-forwarder/cert.pem</td>
  </tr>
  <tr>
    <td><tt>['network']['ssl certificate']</tt></td>
    <td>String</td>
    <td>The path to find the SSL Certificate</td>
    <td>/etc/pki/tls/certs/logstash-forwarder/cert.pem</td>
  </tr>
  <tr>
    <td><tt>['network']['ssl key']</tt></td>
    <td>String</td>
    <td>The path to find the SSL Private Key</td>
    <td>/etc/pki/tls/certs/logstash-forwarder/key.pem</td>
  </tr>
  <tr>
    <td><tt>['network']['ssl ca']</tt></td>
    <td>String</td>
    <td>The path to find the SSL CA Certificate</td>
    <td>/etc/pki/tls/certs/logstash-forwarder/ca.pem</td>
  </tr>
  <tr>
    <td><tt>['network']['timeout']</tt></td>
    <td>String</td>
    <td>Seconds to wait before connecting to next server</td>
    <td>15</td>
  </tr>
  <tr>
    <td><tt>['haproxy']['defaults']['maxconn']</tt></td>
    <td>String (well, a number in quotes, really)</td>
    <td>The DEFAULT maximum number of concurrent connections the frontend will accept to serve. Excess connections will be queued by the system in the socket's listen queue and will be served once a connection closes.  (See: http://code.google.com/p/haproxy-docs/wiki/maxconn)</td>
    <td><tt>60000</tt></td>
  </tr>
  <tr>
    <td><tt>['files']</tt></td>
    <td>Hash</td>
    <td>The List of files to track and associated fields to add</td>
    <td>{}</td>
  </tr>
</table>

# Usage

Thats great but how do I use it.

## Point to your servers

Put this in a recipe, probably in your base cookbook

```ruby
servers = search(
  :node,
  "role:elk_server AND chef_environment:#{node.chef_environment}"
).map do |node|
  "#{node['fqdn']}:5043"
end

node.set['elk_forwarder']['config']['network']['servers'] = servers
```

## Grab your Lumberjack Certificate

This one is pretty much up to you, but there is a built in recipe for this
that pulls a certificate from a data bag item.  I will use that as an example
assuming that you stored your CA certificate in the `ca certificate` key in the
`logstash` data bag item in the `certificates` data bag

In your Attributes file

```ruby
set['elk_forwarder']['certs']['ca_data_bag'] = 'certificates'
set['elk_forwarder']['certs']['ca_data_bag_item'] = 'logstash'
set['elk_forwarder']['certs']['ca_data_bag_item_key'] = 'ca certificate'
```

In your Recipe

```ruby
include_recipe 'elk_forwarder::certs'
```

## Configure files to forward

From your Attributes

```ruby
set['elk_forwarder']['config']['files']['myapp']['paths'] = ['/var/log/myapp.log']
set['elk_forwarder']['config']['files']['myapp']['fields']['type'] = 'myapp'
set['elk_forwarder']['config']['files']['myapp']['fields']['foo'] = 'bar'
```

Or from your recipe. This one loops through a list of apps

```ruby
apps.each do |app|
  node.set['elk_forwarder']['config']['files']['myapp']['paths'] = ["/var/log/#{app}.log"]
  node.set['elk_forwarder']['config']['files']['myapp']['fields']['type'] = 'rails_app'
  node.set['elk_forwarder']['config']['files']['myapp']['fields']['app'] = app
end
```

*As a side note all attribute modifications need to happen at compile time*

# Recipes

## default

Installs and configures the logstash-forwarder

1. Install logstash-forwarder using the `_source` or `_package` recipes
2. Include various recipes for this cookbook:
    * `elk_forwarder::configure`

## configure

Configures the forwarder with the `['elk_forwarder']['config']` hash

1. Creates the config file: `#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf`

## certs

Installs SSL Certs and Keys from data bags to the paths specified in the configuration
from:

* `node['elk_forwarder']['network']['ssl ca']`
* `node['elk_forwarder']['network']['ssl certificate']`
* `node['elk_forwarder']['network']['ssl key']`

The following attributes are used to determine the location of the certs/keys

```ruby
# The Server's CA Certificate. This cert is required
set['elk_forwarder']['certs']['ca_data_bag'] = 'certificates'
set['elk_forwarder']['certs']['ca_data_bag_item'] = 'logstash'
set['elk_forwarder']['certs']['ca_data_bag_item_key'] = 'ca certificate'

# The Client Certificate (optional)
set['elk_forwarder']['certs']['certificate_data_bag'] = 'certificates'
set['elk_forwarder']['certs']['certificate_data_bag_item'] = 'logstash'
set['elk_forwarder']['certs']['certificate_data_bag_item_key'] = 'ca certificate'

# The Client key (optional)
set['elk_forwarder']['certs']['key_data_bag'] = 'certificates'
set['elk_forwarder']['certs']['key_data_bag_item'] = 'logstash'
set['elk_forwarder']['certs']['key_data_bag_item_key'] = 'ca certificate'
```

# Usage

Include this recipe in a wrapper cookbook:

metadata.rb

```ruby
depends 'elk_forwarder', '~> 1.0'
```

recipes/your_recipe.rb

```ruby
include_recipe 'elk_forwarder::default'
```

### Certificates

Generating and distributing SSL Certificates is out of scope for this cookbook. Your wrapper cookbook will
need to configure the SSL Certificates and Keys.  See the
[Certificate Notes](https://github.com/elastic/logstash-forwarder#important-tlsssl-certificate-notes)
on the logstash forwarder repo for help.

However, with that said there is a `certs` recipe that you can use at your own risk to pull certs from a data bag.

You can tweak the Certificate locations in the `[elk_forwarder]['config']['network']['ssl *']` attributes

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests with `kitchen test`, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Author:: EverTrue, inc. (devops@evertrue.com)
