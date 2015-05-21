# elk_forwarder [![Build Status](https://travis-ci.org/evertrue/elk_forwarder-cookbook.svg)](https://travis-ci.org/evertrue/elk_forwarder-cookbook) [![Dependency Status](https://gemnasium.com/evertrue/elk_forwarder-cookbook.svg)](https://gemnasium.com/evertrue/elk_forwarder-cookbook)

Installs and configures the [logstash-forwarder](https://github.com/elastic/logstash-forwarder) to forward specified logs to specified servers

# Requirements

* `golang` cookbook

# LWRPs

## elk_forwarder_log

Configures the forwarder to monitor the specified files

### Usage

```
elk_forwarder_log 'apache error logs' do
    files ['/var/log/apache2/error.log']
    fields type: 'apache2', otherfield: 'othervalue'
end
```

# Recipes

## default

Installs and configures the logstash-forwarder

1. Install logstash-forwarder using the `_source` or `_package` recipes
2. Include various recipes for this cookbook:
    * `elk_forwarder::configure`

## configure

Configures the forwarder with the `['elk_forwarder']['config']` hash

1. Creates the config file: `#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf`

# Usage

Include this recipe in a wrapper cookbook:

metadata.rb

```
depends 'elk_forwarder', '~> 1.0'
```

your_recipe.rb

```
elk_forwarder_log 'apache error logs' do
    files ['/var/log/apache2/error.log']
    fields type: 'apache2', otherfield: 'othervalue'
end

...

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
