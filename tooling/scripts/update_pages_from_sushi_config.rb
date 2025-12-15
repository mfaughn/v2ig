#!/usr/bin/env ruby
# encoding: UTF-8

# Script to update v2plus.xml pages from sushi-config.yaml
# Reads the pages structure from sushi-config.yaml and updates the <page> elements in v2plus.xml

require 'yaml'
require 'rexml/document'
require 'fileutils'

# Force UTF-8 encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# File paths
CONFIG_FILE = 'page-config.yaml'
PAGE_CONFIG = File.join(__dir__, '..', '..', CONFIG_FILE)
V2PLUS_XML = File.join(__dir__, '..', '..', 'input', 'v2plus.xml')
BACKUP_DIR = File.join(__dir__, '..', '..', 'backups', 'xml_backups')

class SushiToV2PlusConverter

  def initialize
    @indent_size = 2
  end

  def convert
    puts "=" * 70
    puts "Updating v2plus.xml pages from #{CONFIG_FILE}"
    puts "=" * 70
    puts

    # Read page-config.yaml
    unless File.exist?(PAGE_CONFIG)
      abort "❌ Error: #{CONFIG_FILE} not found at #{PAGE_CONFIG}"
    end

    puts "Reading #{CONFIG_FILE}..."
    sushi_config = YAML.load_file(PAGE_CONFIG)

    unless sushi_config['pages']
      abort "❌ Error: No 'pages' section found in #{CONFIG_FILE}"
    end

    pages = sushi_config['pages']
    puts "✓ Found #{count_pages(pages)} page(s) in #{CONFIG_FILE}"
    puts

    # Read v2plus.xml
    unless File.exist?(V2PLUS_XML)
      abort "❌ Error: v2plus.xml not found at #{V2PLUS_XML}"
    end

    puts "Reading v2plus.xml..."
    xml_content = File.read(V2PLUS_XML, encoding: 'UTF-8')
    doc = REXML::Document.new(xml_content)

    # Create backup
    create_backup(V2PLUS_XML)

    # Find the definition element
    definition = doc.elements['ImplementationGuide/definition']
    unless definition
      abort "❌ Error: No <definition> element found in v2plus.xml"
    end

    # Remove all existing page elements
    definition.elements.delete_all('page')
    puts "✓ Removed existing <page> elements"

    # Convert pages to XML and add to definition
    puts "Converting pages to XML..."
    root_page = convert_pages_to_xml(pages, doc)

    # Insert at the beginning of definition (before parameters)
    first_param = definition.elements['parameter']
    if first_param
      definition.insert_before(first_param, root_page)
    else
      definition.add_element(root_page)
    end

    puts "✓ Added #{count_pages(pages)} page(s) to v2plus.xml"
    puts

    # Write back to file with proper formatting
    puts "Writing updated v2plus.xml..."
    formatter = REXML::Formatters::Pretty.new(@indent_size)
    formatter.compact = true

    output = ''
    formatter.write(doc, output)

    # Remove duplicate XML declaration if present (REXML adds one)
    output = output.sub(/^<\?xml[^?]*\?>\s*/, '')

    # Add single XML declaration
    final_output = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + output

    File.write(V2PLUS_XML, final_output, encoding: 'UTF-8')

    puts "✓ Successfully updated v2plus.xml"
    puts
    puts "Backup saved to: #{BACKUP_DIR}"
    puts "=" * 70
  end

  private

  def count_pages(pages_hash, count = 0)
    pages_hash.each do |key, value|
      count += 1
      if value.is_a?(Hash) && value.keys.any? { |k| k.end_with?('.md', '.xml', '.xhtml', '.html') }
        # Has child pages
        child_pages = value.select { |k, v| k.end_with?('.md', '.xml', '.xhtml', '.html') }
        count = count_pages(child_pages, count)
      end
    end
    count
  end

  def convert_pages_to_xml(pages_hash, doc)
    # In SUSHI config, all top-level pages are siblings
    # But in FHIR IG XML, we need ONE root page with children
    # Convention: index is root, all others are siblings under it

    # Try both .md and .xml extensions for index
    root_name = pages_hash.key?('index.xml') ? 'index.xml' : 'index.md'
    root_config = pages_hash[root_name] || {}

    unless pages_hash.key?(root_name)
      puts "⚠️  Warning: No index found, using first page as root"
      root_name = pages_hash.keys.first
      root_config = pages_hash[root_name]
    end

    # Create root page element
    root_element = REXML::Element.new('page')

    html_name = root_name.gsub(/\.(md|xml|xhtml)$/, '.html')
    name_elem = root_element.add_element('name')
    name_elem.attributes['value'] = html_name

    if root_config['title']
      title_elem = root_element.add_element('title')
      title_elem.attributes['value'] = root_config['title']
    end

    generation = root_config['generation'] == 'markdown' ? 'html' : (root_config['generation'] || 'html')
    gen_elem = root_element.add_element('generation')
    gen_elem.attributes['value'] = generation

    # Add all other top-level pages as children of root
    pages_hash.each do |page_name, page_config|
      next if page_name == root_name  # Skip the root itself

      child_element = create_page_element(page_name, page_config, pages_hash, doc)
      root_element.add_element(child_element)
    end

    root_element
  end

  def create_page_element(page_name, page_config, parent_pages_hash, doc, is_root = false)
    page_element = REXML::Element.new('page')

    # Convert .md or .xml to .html for the name value
    html_name = page_name.gsub(/\.(md|xml|xhtml)$/, '.html')

    name_elem = page_element.add_element('name')
    name_elem.attributes['value'] = html_name

    # Add title if specified
    if page_config.is_a?(Hash) && page_config['title']
      title_elem = page_element.add_element('title')
      title_elem.attributes['value'] = page_config['title']
    end

    # Add generation (default to 'html' for markdown files)
    generation = 'html'
    if page_config.is_a?(Hash) && page_config['generation']
      generation = page_config['generation'] == 'markdown' ? 'html' : page_config['generation']
    end

    gen_elem = page_element.add_element('generation')
    gen_elem.attributes['value'] = generation

    # Process child pages
    if page_config.is_a?(Hash)
      child_pages = page_config.select { |k, v| k.end_with?('.md', '.xml', '.xhtml', '.html') }

      child_pages.each do |child_name, child_config|
        child_element = create_page_element(child_name, child_config, page_config, doc)
        page_element.add_element(child_element)
      end
    end

    page_element
  end

  def create_backup(xml_file)
    # Only create backup if it doesn't exist yet
    backup_file = File.join(BACKUP_DIR, File.basename(xml_file))

    unless File.exist?(backup_file)
      FileUtils.mkdir_p(BACKUP_DIR)
      FileUtils.cp(xml_file, backup_file)
      puts "✓ Created backup: #{backup_file}"
    end
  end
end

# Main execution
if __FILE__ == $0
  converter = SushiToV2PlusConverter.new
  converter.convert
end
