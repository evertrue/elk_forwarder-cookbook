action :track do
  new_log = {
    name: new_resource.name,
    paths: new_resource.paths,
    fields: new_resource.fields
  }

  # Grab the Array of files
  files = node['elk_forwarder']['config']['files']

  # Remove the file with the new_resource name if it exists (updating)
  files = files.select do |file|
    file['name'] != new_resource.name
  end

  files = (files << new_log).uniq

  node.set['elk_forwarder']['config']['files'] = files

  directory node['elk_forwarder']['config_dir'] do
    recursive true
  end

  t = template "Logstash Forwarder Adding '#{new_log[:name]}' Configuration" do
    path "#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf"
    cookbook 'elk_forwarder'
    source 'logstash-forwarder.conf.erb'
    user node['elk_forwarder']['user']
    group node['elk_forwarder']['group']
    mode '0640'
    variables(
      config: JSON.parse(node['elk_forwarder']['config'].to_json)
    )
    notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
  end

  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :untrack do
  files = node['elk_forwarder']['config']['files']

  # Remove the file with the new_resource name if it exists (updating)
  files = files.select do |file|
    file['name'] != new_resource.name
  end

  node.set['elk_forwarder']['config']['files'] = files

  f = file "#{node['elk_forwarder']['config_dir']}/logstash-forwarder.conf" do
    user node['elk_forwarder']['user']
    group node['elk_forwarder']['group']
    mode '0640'
    content JSON.pretty_generate(node['elk_forwarder']['config'])
    notifies :restart, "service[#{node['elk_forwarder']['service_name']}]"
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
