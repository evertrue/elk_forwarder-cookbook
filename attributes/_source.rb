default['elk_forwarder']['git_repo'] = 'https://github.com/elastic/logstash-forwarder'
default['elk_forwarder']['git_ref'] = 'v0.4.0'
default['elk_forwarder']['build_dir'] = "#{Chef::Config[:file_cache_path]}/logstash-forwarder-build"
