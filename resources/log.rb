actions :track, :untrack
default_action :track

attribute :name,           kind_of: String, name_attribute: true
attribute :paths,          kind_of: Array
attribute :fields,         kind_of: Hash
