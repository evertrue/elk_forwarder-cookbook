name             'elk_forwarder'
maintainer       'EverTrue, inc.'
maintainer_email 'devops@evertrue.com'
license          'apache2'
description      'Installs logstash-forwarder for use in an ELK Cluster'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 7'

depends 'golang', '~> 1.5'
depends 'logrotate', '~> 1.9'
