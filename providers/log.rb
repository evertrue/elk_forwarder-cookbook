action :track do
  new_log = {
    name: new_resource.name,
    paths: new_resource.paths,
    fields: new_resource.fields
  }
  before = node['elk_forwarder']['config']['files'].to_json

  files = node['elk_forwarder']['config']['files'].merge(new_log)
  node.set['elk_forwarder']['config']['files'] = files

  if before != node['elk_forwarder']['config']['files'].to_json
    new_resource.updated_by_last_action(true)
  end
end

action :untrack do
  files = node['elk_forwarder']['config']['files'].select do |f|
    new_resource.updated_by_last_action(true) unless f.name == new_resource.name
    f.name == new_resource.name
  end
  node.set['elk_forwarder']['config']['files'] = files
end
