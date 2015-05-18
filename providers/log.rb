action :track do
  new_log = {
    name: new_resource.name,
    paths: new_resource.paths,
    fields: new_resource.fields
  }
  before = node['elk_forwarder']['config']['files'].to_json

  files = (node['elk_forwarder']['config']['files'] + [new_log]).uniq
  node.set['elk_forwarder']['config']['files'] = files

  if before != node['elk_forwarder']['config']['files'].to_json
    new_resource.updated_by_last_action(true)
  end
end
