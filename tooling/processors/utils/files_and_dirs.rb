module V2plusProcessors
  module_function

  def check_ig_dir(dir)
    raise "#{dir} does not exist" unless File.exist?(dir)
    dir
  end
  
  def input_dir
    check_ig_dir(File.expand_path('../../input', __dir__))
  end
  
  def includes_dir
    check_ig_dir(File.join(input_dir, 'includes'))
  end

  def pagecontent_dir
    check_ig_dir(File.join(input_dir, 'pagecontent'))
  end
  
  def resources_dir
    check_ig_dir(File.join(input_dir, 'resources'))
  end
  
  def sourceOfTruth_dir
    check_ig_dir(File.join(input_dir, 'sourceOfTruth'))
  end
  
  def data_types_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'data-type'))
  end
  
  def complex_data_types_dir
    check_ig_dir(File.join(data_types_dir, 'complex'))
  end
  
  def complex_data_types_files
    Dir.glob(File.join(complex_data_types_dir, 'complex-data-types', '*.json'))
  end

  def primitive_data_types_dir
    check_ig_dir(File.join(data_types_dir, 'primitive'))
  end
  
  def primitive_data_types_files
    Dir.glob(File.join(primitive_data_types_dir, 'primitives', '*.json'))
  end

  def message_structures_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'message-structure'))
  end
  
  def segments_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'segment'))
  end
  
  def acknowledgement_choreographies_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'acknowledgement-choreography'))
  end
  
  def events_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'event'))
  end

  def messages_dir
    check_ig_dir(File.join(sourceOfTruth_dir, 'event'))
  end
end
