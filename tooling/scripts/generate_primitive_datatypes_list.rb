#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'

Encoding.default_external = Encoding::UTF_8

# Directories
REPO_ROOT = File.expand_path('../..', __dir__)
PRIMITIVE_DT_DIR = File.join(REPO_ROOT, 'input', 'sourceOfTruth', 'data-type', 'primitive', 'primitives')
OUTPUT_FILE = File.join(REPO_ROOT, 'input', 'pagecontent', 'primitive-data-types.xml')

def extract_datatype_info(json_file)
  data = JSON.parse(File.read(json_file, encoding: 'UTF-8'))

  # Extract description from title by removing "HL7 v2 " and " Primitive Type"
  title = data['title'] || data['name']
  description = title
    .gsub(/^HL7 v2 /, '')
    .gsub(/ Primitive Type$/, '')

  {
    id: data['id'],
    title: title,
    description: description,
    name: data['name']
  }
rescue StandardError => e
  puts "  ⚠️  Error reading #{json_file}: #{e.message}"
  nil
end

def generate_primitive_datatypes_page
  puts "=" * 70
  puts "Generating Primitive Data Types List Page"
  puts "=" * 70
  puts

  # Get all JSON files
  json_files = Dir.glob(File.join(PRIMITIVE_DT_DIR, '*.json')).sort

  if json_files.empty?
    puts "ERROR: No JSON files found in #{PRIMITIVE_DT_DIR}"
    exit 1
  end

  puts "Found #{json_files.length} primitive data type files"
  puts

  # Extract info from each file
  datatypes = []
  json_files.each do |file|
    info = extract_datatype_info(file)
    datatypes << info if info
  end

  # Sort by ID
  datatypes.sort_by! { |dt| dt[:id] }

  puts "Processing #{datatypes.length} data types..."
  puts

  # Generate HTML content
  html_lines = []
  html_lines << '<h2>HL7 v2+ Primitive Data Types</h2>'
  html_lines << '<p>This page lists all primitive data types defined in HL7 v2+. Click on a data type code to view its full definition.</p>'
  html_lines << '<table class="grid">'
  html_lines << '  <thead>'
  html_lines << '    <tr>'
  html_lines << '      <th>Code</th>'
  html_lines << '      <th>Name</th>'
  html_lines << '      <th>Description</th>'
  html_lines << '    </tr>'
  html_lines << '  </thead>'
  html_lines << '  <tbody>'

  datatypes.each do |dt|
    # FHIR IG Publisher generates pages as StructureDefinition-{id}.html
    link = "StructureDefinition-#{dt[:id]}.html"

    html_lines << '    <tr>'
    html_lines << "      <td><a href=\"#{link}\">#{dt[:id]}</a></td>"
    html_lines << "      <td>#{dt[:name]}</td>"
    html_lines << "      <td>#{dt[:description]}</td>"
    html_lines << '    </tr>'
  end

  html_lines << '  </tbody>'
  html_lines << '</table>'

  # Wrap in FHIR XHTML
  xhtml_content = <<~XML
    <div xmlns="http://www.w3.org/1999/xhtml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://hl7.org/fhir ../../input-cache/schemas/R5/fhir-single.xsd">
      #{html_lines.join("\n  ")}
    </div>
  XML

  # Write to file
  File.write(OUTPUT_FILE, xhtml_content, encoding: 'UTF-8')

  puts "=" * 70
  puts "Successfully created: #{OUTPUT_FILE}"
  puts "Total data types: #{datatypes.length}"
  puts "=" * 70
  puts
  puts "Links will work in all contexts:"
  puts "  - Local IG build: file:///.../output/StructureDefinition-ST.html"
  puts "  - CI build: https://.../StructureDefinition-ST.html"
  puts "  - Published: https://hl7.org/.../StructureDefinition-ST.html"
end

# Run the generation
generate_primitive_datatypes_page
