#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'asciidoctor'

Encoding.default_external = Encoding::UTF_8

# Directories
REPO_ROOT = File.expand_path('../..', __dir__)
WEBSITE_DOMAINS = File.join(REPO_ROOT, 'website', 'domains')
INPUT_PAGECONTENT = File.join(REPO_ROOT, 'input', 'pagecontent')
SUSHI_CONFIG = File.join(REPO_ROOT, 'sushi-config.yaml')

# FHIR XHTML wrapper template
XHTML_WRAPPER = <<~XML
  <div xmlns="http://www.w3.org/1999/xhtml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://hl7.org/fhir ../../input-cache/schemas/R5/fhir-single.xsd">
  %s
  </div>
XML

def convert_adoc_to_html(adoc_file)
  # Use Asciidoctor Ruby API to convert ADOC to HTML
  # header_footer: false - suppress header/footer, output only body content
  begin
    doc = Asciidoctor.convert_file(adoc_file,
      safe: :unsafe,
      header_footer: false,
      to_file: false
    )
    doc
  rescue StandardError => e
    puts "  ⚠️  AsciiDoctor error: #{e.message}"
    nil
  end
end

def wrap_in_xhtml(html_content)
  # Indent the HTML content for better formatting
  indented_content = html_content.lines.map { |line| "  #{line}" }.join
  XHTML_WRAPPER % indented_content.rstrip
end

def find_adoc_source(page_name, parent_path)
  # Special cases for top-level pages
  if parent_path.empty?
    case page_name
    when 'index'
      return :skip  # Already exists as XML
    when 'introduction', 'foundation', 'foundation-intro', 'control'
      return nil  # No source available
    when 'data-types', 'complex-data-types', 'primitive-data-types'
      return :skip  # Already exist or are templates
    when 'domains'
      return File.join(WEBSITE_DOMAINS, 'domains.adoc')
    else
      return File.join(WEBSITE_DOMAINS, "#{page_name}.adoc")
    end
  end

  # For nested pages under domains
  if parent_path.first == 'domains'
    domain_path = parent_path[1..-1].map { |p| p.tr('-', '_') }
    page_name_underscore = page_name.tr('-', '_')

    # Special case: medical-records → medical_records/document_management.adoc
    if page_name == 'medical-records'
      special_path = File.join(WEBSITE_DOMAINS, *domain_path, 'medical_records', 'document_management.adoc')
      return special_path if File.exist?(special_path)
    end

    # Special case: supply-erp → clinical/supply/supply.adoc
    if page_name == 'supply-erp'
      special_path = File.join(WEBSITE_DOMAINS, 'clinical', 'supply', 'supply.adoc')
      return special_path if File.exist?(special_path)
    end

    # Try: website/domains/administration/registration/registration.adoc
    full_path = File.join(WEBSITE_DOMAINS, *domain_path, page_name_underscore, "#{page_name_underscore}.adoc")
    return full_path if File.exist?(full_path)

    # Try: website/domains/administration/administration.adoc (for domain-level pages)
    domain_file = File.join(WEBSITE_DOMAINS, *domain_path, "#{page_name_underscore}.adoc")
    return domain_file if File.exist?(domain_file)

    # Try without nesting: website/domains/clinical/blood_bank.adoc
    if domain_path.any?
      alt_path = File.join(WEBSITE_DOMAINS, *domain_path, "#{page_name_underscore}.adoc")
      return alt_path if File.exist?(alt_path)
    end
  end

  nil
end

def extract_pages_from_config(config, parent_path = [])
  pages = []

  config_pages = config['pages'] || {}
  config_pages.each do |page_file, page_config|
    page_name = page_file.sub(/\.md$/, '')

    # Add this page
    pages << {
      name: page_name,
      parent_path: parent_path.dup,
      generation: page_config['generation']
    }

    # Recursively process child pages
    if page_config.is_a?(Hash)
      page_config.each do |key, value|
        next if ['title', 'generation'].include?(key)

        child_pages = extract_pages_from_config(
          { 'pages' => { key => value } },
          parent_path + [page_name]
        )
        pages.concat(child_pages)
      end
    end
  end

  pages
end

def process_pages
  puts "=" * 70
  puts "Converting AsciiDoc to XHTML for FHIR IG Publisher"
  puts "=" * 70
  puts

  # Read sushi-config.yaml
  puts "Reading sushi-config.yaml..."
  config = YAML.load_file(SUSHI_CONFIG)
  pages = extract_pages_from_config(config)

  created_count = 0
  skipped_count = 0
  error_count = 0

  pages.each do |page_info|
    page_name = page_info[:name]
    parent_path = page_info[:parent_path]

    # Find source ADOC file
    adoc_source = find_adoc_source(page_name, parent_path)

    if adoc_source == :skip
      puts "  #{page_name}: Skipping (already exists or template)"
      skipped_count += 1
      next
    end

    if adoc_source.nil? || !File.exist?(adoc_source)
      puts "⚠️  #{page_name}.xml: No ADOC source found"
      error_count += 1
      next
    end

    # Convert ADOC to HTML
    html_content = convert_adoc_to_html(adoc_source)

    if html_content.nil?
      error_count += 1
      next
    end

    # Wrap in FHIR XHTML
    xhtml_content = wrap_in_xhtml(html_content)

    # Write to pagecontent as .xml
    output_file = File.join(INPUT_PAGECONTENT, "#{page_name}.xml")
    File.write(output_file, xhtml_content, encoding: 'UTF-8')

    # Show relative paths for cleaner output
    relative_source = adoc_source.sub(REPO_ROOT, '')
    puts "✓ #{page_name}.xml ← #{relative_source}"
    created_count += 1
  end

  puts
  puts "=" * 70
  puts "Summary:"
  puts "  Pages processed: #{pages.length}"
  puts "  Files created: #{created_count}"
  puts "  Files skipped: #{skipped_count}"
  puts "  Errors/Missing: #{error_count}"
  puts "=" * 70
end

# Run the conversion
process_pages
