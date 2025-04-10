utils = File.expand_path('utils', __dir__)
Dir.glob(File.join(utils,'*.rb')).each { |f| require f }

lists = File.expand_path('lists', __dir__)
Dir.glob(File.join(lists,'*.rb')).each { |f| require f }

# V2plusProcessors.create_primitive_data_types_include
# V2plusProcessors.create_complex_data_types_include