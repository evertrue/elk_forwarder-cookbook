action :track do
  new_log = {
    name: new_resource.name,
    paths: new_resource.paths,
    fields: new_resource.fields
  }
  node.set['elk_forwarder']['config']['files'] = node['elk_forwarder']['config']['files'].merge(new_log)
end

action :untrack do
  node.set['elk_forwarder']['config']['files'] = node['elk_forwarder']['config']['files'].select do |f|
    f.name == new_resource.name
  end
end
