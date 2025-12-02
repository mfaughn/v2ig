#!/usr/bin/env ruby
# encoding: UTF-8

# Test script to inject content for a single data type
# Usage: ruby inject_adoc_single_type.rb <datatype-code>
# Example: ruby inject_adoc_single_type.rb MO

require_relative 'inject_adoc_into_json'

if ARGV.empty?
  puts "Usage: #{$0} <datatype-code>"
  puts "Example: #{$0} MO"
  exit 1
end

data_type_code = ARGV[0].upcase

class SingleTypeInjector < AdocToJsonInjector
  def initialize(data_type_code)
    super()
    @data_type_code = data_type_code
  end

  def process_single_type
    puts "=" * 70
    puts "Processing single data type: #{@data_type_code}"
    puts "=" * 70
    puts

    # Find main file
    main_file = File.join(COMPLEX_DT_ADOC_DIR, "#{@data_type_code}.adoc")
    component_dir = File.join(COMPLEX_DT_ADOC_DIR, "#{@data_type_code}-components")

    if File.exist?(main_file)
      puts "Processing main file: #{File.basename(main_file)}"
      process_adoc_file(main_file)
    else
      puts "⚠️  Main file not found: #{main_file}"
    end

    # Find component files
    if Dir.exist?(component_dir)
      component_files = Dir.glob(File.join(component_dir, "#{@data_type_code}-*.adoc")).sort
      puts "Found #{component_files.length} component files"
      puts

      component_files.each do |component_file|
        process_adoc_file(component_file)
      end
    else
      puts "⚠️  Component directory not found: #{component_dir}"
    end

    print_summary
  end
end

injector = SingleTypeInjector.new(data_type_code)
injector.process_single_type
