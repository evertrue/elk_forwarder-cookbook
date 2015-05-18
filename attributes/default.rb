# How to install logstash-forwarder, package or source install
default['elk_forwarder']['install_type'] = 'source'

# The directory to place all the configuration files and SSL Certs
default['elk_forwarder']['config_dir'] = '/etc/logstash-forwarder'

# The Name of the service. Does not affect package based install
default['elk_forwarder']['service_name'] = 'logstash-forwarder'

# The Directory that logstash-forwarder is installed to.
# Does not affect package installs so don't change if using packages
default['elk_forwarder']['install_dir'] = '/opt/logstash-forwarder'

# The Directory to Log the Logstash Forwarder Stuff to.
default['elk_forwarder']['log_dir'] = '/var/log/logstash-forwarder'

# Extra Args for the Logstash forwarder Daemon
default['elk_forwarder']['daemon_args'] = '-spool-size 5'

# A list of downstream servers listening for our messages.
# logstash-forwarder will pick one at random and only switch if
# the selected one appears to be dead or unresponsive
default['elk_forwarder']['config']['network']['servers'] = []

# The path to your client ssl certificate (optional)
default['elk_forwarder']['config']['network']['ssl certificate'] =
  '/etc/pki/tls/certs/logstash-forwarder/cert.pem'

# The path to your client ssl key (optional)
default['elk_forwarder']['config']['network']['ssl key'] =
  '/etc/pki/tls/private/logstash-forwarder/key.pem'

# The path to your trusted ssl CA file. This is used
# to authenticate your downstream server.
default['elk_forwarder']['config']['network']['ssl ca'] =
  '/etc/pki/tls/certs/logstash-forwarder/ca.pem'

# Network timeout in seconds. This is most important for
# logstash-forwarder determining whether to stop waiting for an
# acknowledgement from the downstream server. If an timeout is reached,
# logstash-forwarder will assume the connection or server is bad and
# will connect to a server chosen at random from the servers list.
default['elk_forwarder']['config']['network']['timeout'] = 15

# The list of files configurations
# An array of hashes. Each hash tells what paths to watch and
# what fields to annotate on events from those paths.
#
# {
#   "paths": [
#     # single paths are fine
#     "/var/log/messages",
#     # globs are fine too, they will be periodically evaluated
#     # to see if any new files match the wildcard.
#     "/var/log/*.log"
#   ],
#
#   # A dictionary of fields to annotate on each event.
#   "fields": { "type": "syslog" }
# },
default['elk_forwarder']['config']['files'] = []
