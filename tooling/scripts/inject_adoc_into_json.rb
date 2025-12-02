#!/usr/bin/env ruby
# encoding: UTF-8

# Script to inject converted AsciiDoc content into FHIR StructureDefinition JSON files
# Reads :target-element: attribute from ADOC files to determine injection targets

require 'json'
require 'fileutils'
require_relative 'asciidoc_to_markdown'

# Force UTF-8 encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Directories
COMPLEX_DT_ADOC_DIR = File.join(__dir__, '..', '..', 'website', 'data_structures', 'data_types', 'complex')
COMPLEX_DT_JSON_DIR = File.join(__dir__, '..', '..', 'input', 'sourceOfTruth', 'data-type', 'complex', 'complex-data-types')
BACKUP_DIR = File.join(__dir__, '..', '..', 'backups', 'json_backups')

class AdocToJsonInjector

  def initialize
    @converter = AsciiDocToMarkdownConverter.new
    @stats = {
      files_processed: 0,
      main_types_updated: 0,
      components_updated: 0,
      errors: []
    }
  end

  def process_all_adoc_files
    puts "=" * 70
    puts "Injecting AsciiDoc content into JSON StructureDefinitions"
    puts "=" * 70
    puts

    # Find all ADOC files (main files and components)
    main_files = Dir.glob(File.join(COMPLEX_DT_ADOC_DIR, '*.adoc'))
    component_files = Dir.glob(File.join(COMPLEX_DT_ADOC_DIR, '*-components', '*.adoc'))

    all_files = main_files + component_files

    puts "Found #{main_files.length} main data type files"
    puts "Found #{component_files.length} component files"
    puts "Total: #{all_files.length} files to process"
    puts

    all_files.each do |adoc_file|
      process_adoc_file(adoc_file)
    end

    print_summary
  end

  def process_adoc_file(adoc_file)
    @stats[:files_processed] += 1
    filename = File.basename(adoc_file)

    begin
      # Read the ADOC file and extract target-element attribute
      target_element = extract_target_element(adoc_file)

      if target_element.nil?
        puts "⚠️  #{filename}: No :target-element: attribute found - skipping"
        @stats[:errors] << "#{filename}: Missing :target-element: attribute"
        return
      end

      # Convert ADOC content to Markdown
      markdown_content = @converter.convert_file(adoc_file)

      if markdown_content.strip.empty?
        puts "⚠️  #{filename}: Converted content is empty - skipping"
        @stats[:errors] << "#{filename}: Empty converted content"
        return
      end

      # Determine JSON file and inject
      if target_element.include?('.')
        # Component file (e.g., "CWE.1")
        inject_component(target_element, markdown_content, filename)
      else
        # Main file (e.g., "CWE")
        inject_main_type(target_element, markdown_content, filename)
      end

    rescue => e
      puts "❌ #{filename}: Error - #{e.message}"
      @stats[:errors] << "#{filename}: #{e.message}"
    end
  end

  private

  def extract_target_element(adoc_file)
    content = File.read(adoc_file, encoding: 'UTF-8')

    # Look for :target-element: attribute
    match = content.match(/^:target-element:\s*(.+)$/i)
    return nil unless match

    match[1].strip
  end

  def inject_main_type(data_type_code, markdown_content, source_file)
    json_file = File.join(COMPLEX_DT_JSON_DIR, "#{data_type_code.downcase}.json")

    unless File.exist?(json_file)
      puts "⚠️  #{source_file}: JSON file not found: #{json_file}"
      @stats[:errors] << "#{source_file}: JSON file not found"
      return
    end

    # Read and parse JSON
    json_content = File.read(json_file, encoding: 'UTF-8')
    data = JSON.parse(json_content)

    # Create backup
    create_backup(json_file)

    # Inject into description field
    data['description'] = markdown_content

    # Write back to file
    File.write(json_file, JSON.pretty_generate(data), encoding: 'UTF-8')

    puts "✓ #{source_file} → #{data_type_code}.json (description field)"
    @stats[:main_types_updated] += 1
  end

  def inject_component(target_element, markdown_content, source_file)
    # Parse target element (e.g., "CWE.1" -> type="CWE", component="1")
    parts = target_element.split('.')
    data_type_code = parts[0]
    component_num = parts[1]

    json_file = File.join(COMPLEX_DT_JSON_DIR, "#{data_type_code.downcase}.json")

    unless File.exist?(json_file)
      puts "⚠️  #{source_file}: JSON file not found: #{json_file}"
      @stats[:errors] << "#{source_file}: JSON file not found"
      return
    end

    # Read and parse JSON
    json_content = File.read(json_file, encoding: 'UTF-8')
    data = JSON.parse(json_content)

    # Create backup (only once per file)
    create_backup(json_file)

    # Find the element in differential.element array
    element_path = "#{data_type_code}.#{component_num}"
    element = find_element(data, element_path)

    unless element
      puts "⚠️  #{source_file}: Element #{element_path} not found in JSON"
      @stats[:errors] << "#{source_file}: Element #{element_path} not found"
      return
    end

    # Fix the "defintion" typo if it exists
    if element.key?('defintion')
      element['definition'] = element.delete('defintion')
    end

    # Inject into definition field
    element['definition'] = markdown_content

    # Write back to file
    File.write(json_file, JSON.pretty_generate(data), encoding: 'UTF-8')

    puts "✓ #{source_file} → #{data_type_code}.json (#{element_path}.definition)"
    @stats[:components_updated] += 1
  end

  def find_element(data, element_path)
    return nil unless data['differential'] && data['differential']['element']

    data['differential']['element'].find do |elem|
      elem['path'] == element_path
    end
  end

  def create_backup(json_file)
    # Only create backup if it doesn't exist yet
    backup_file = File.join(BACKUP_DIR, File.basename(json_file))

    unless File.exist?(backup_file)
      FileUtils.mkdir_p(BACKUP_DIR)
      FileUtils.cp(json_file, backup_file)
    end
  end

  def print_summary
    puts
    puts "=" * 70
    puts "Summary:"
    puts "  Files processed: #{@stats[:files_processed]}"
    puts "  Main types updated: #{@stats[:main_types_updated]}"
    puts "  Components updated: #{@stats[:components_updated]}"
    puts "  Total updates: #{@stats[:main_types_updated] + @stats[:components_updated]}"
    puts "  Errors: #{@stats[:errors].length}"

    if @stats[:errors].any?
      puts
      puts "Errors:"
      @stats[:errors].each do |error|
        puts "  - #{error}"
      end
    end

    puts
    puts "Backups saved to: #{BACKUP_DIR}"
    puts "=" * 70
  end
end

# Main execution
if __FILE__ == $0
  injector = AdocToJsonInjector.new
  injector.process_all_adoc_files
end
