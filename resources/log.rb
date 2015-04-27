actions :track, :untrack

attribute :file,           kind_of: String, name_attribute: true
attribute :fields,         kind_of: Hash

def initialize(*args)
  super
  @action = :track
end
