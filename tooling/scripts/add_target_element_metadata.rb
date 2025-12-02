#!/usr/bin/env ruby
# encoding: UTF-8

# Script to add :target-element: metadata to complex data type ADOC files
# This metadata indicates where the content should be injected in the JSON StructureDefinition

require 'fileutils'

# Force UTF-8 encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Directory containing complex data type ADOC files
COMPLEX_DT_DIR = File.join(__dir__, '..', '..', 'website', 'data_structures', 'data_types', 'complex')

def add_target_element_to_main_file(file_path, data_type_code)
  content = File.read(file_path, encoding: 'UTF-8')

  # Check if :target-element: already exists
  if content.include?(':target-element:')
    puts "  ✓ Already has :target-element: - skipping"
    return false
  end

  # Add :target-element: after :primitive: line
  updated_content = content.sub(/(:primitive:.*\n)/, "\\1:target-element: #{data_type_code}\n")

  if updated_content != content
    File.write(file_path, updated_content, encoding: 'UTF-8')
    puts "  ✓ Added :target-element: #{data_type_code}"
    return true
  else
    puts "  ✗ Could not find insertion point"
    return false
  end
end

def add_target_element_to_component_file(file_path, target_element)
  content = File.read(file_path, encoding: 'UTF-8')

  # Check if :target-element: already exists
  if content.include?(':target-element:')
    puts "  ✓ Already has :target-element: - skipping"
    return false
  end

  # Add :target-element: after the heading (== line)
  # The heading is on the first line, so we'll add the attribute on line 2
  lines = content.lines
  if lines[0] =~ /^==\s+/
    lines.insert(1, ":target-element: #{target_element}\n")
    updated_content = lines.join

    File.write(file_path, updated_content, encoding: 'UTF-8')
    puts "  ✓ Added :target-element: #{target_element}"
    return true
  else
    puts "  ✗ Could not find heading"
    return false
  end
end

def process_data_type(data_type_dir)
  # Extract data type code from directory name (e.g., "CWE-components" -> "CWE")
  dir_name = File.basename(data_type_dir)
  data_type_code = dir_name.sub('-components', '')

  # Find the main file
  main_file = File.join(File.dirname(data_type_dir), "#{data_type_code}.adoc")

  if File.exist?(main_file)
    puts "\n#{data_type_code}.adoc:"
    add_target_element_to_main_file(main_file, data_type_code)
  end

  # Process all component files
  component_files = Dir.glob(File.join(data_type_dir, "#{data_type_code}-*.adoc")).sort
  component_files.each do |file|
    # Extract component number from filename (e.g., "CWE-1.adoc" -> "1")
    basename = File.basename(file, '.adoc')
    if basename =~ /^#{data_type_code}-(\d+)$/
      component_num = $1
      target = "#{data_type_code}.#{component_num}"

      puts "#{basename}.adoc:"
      add_target_element_to_component_file(file, target)
    end
  end
end

def main
  puts "Adding :target-element: metadata to complex data type ADOC files..."
  puts "=" * 70

  # Find all component directories
  component_dirs = Dir.glob(File.join(COMPLEX_DT_DIR, '*-components')).sort

  total_main = 0
  total_components = 0
  updated_main = 0
  updated_components = 0

  component_dirs.each do |dir|
    dir_name = File.basename(dir)
    data_type_code = dir_name.sub('-components', '')

    # Check main file
    main_file = File.join(COMPLEX_DT_DIR, "#{data_type_code}.adoc")
    if File.exist?(main_file)
      total_main += 1
      puts "\n#{data_type_code}.adoc:"
      if add_target_element_to_main_file(main_file, data_type_code)
        updated_main += 1
      end
    end

    # Process component files
    component_files = Dir.glob(File.join(dir, "#{data_type_code}-*.adoc")).sort
    component_files.each do |file|
      total_components += 1
      basename = File.basename(file, '.adoc')
      if basename =~ /^#{data_type_code}-(\d+)$/
        component_num = $1
        target = "#{data_type_code}.#{component_num}"

        puts "#{basename}.adoc:"
        if add_target_element_to_component_file(file, target)
          updated_components += 1
        end
      end
    end
  end

  puts "\n" + "=" * 70
  puts "Summary:"
  puts "  Main files: #{updated_main}/#{total_main} updated"
  puts "  Component files: #{updated_components}/#{total_components} updated"
  puts "  Total: #{updated_main + updated_components}/#{total_main + total_components} updated"
end

main
