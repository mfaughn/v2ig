require 'json'
require 'rainbow'

module V2plusProcessors
  module_function

  def create_primitive_data_types_include
    data = {}
    lines = []
    lines << '<ul class="columns-2">'
    primitive_data_types_files.each do |f|
      json = JSON.parse(File.read(f))
      lines << "  <li><a href=\"StructureDefinition-#{json['id']}.html\">#{json['id']}</li>" 
    end
    lines << '</ul>'
    File.open(File.join(includes_dir, 'primitive-data-types-list.html'), 'w+') { |f| f.puts lines.join("\n") }
  end
  
  def create_complex_data_types_include
    data = {}
    lines = []
    lines << '<ul class="columns-2">'
    complex_data_types_files.each do |f|
      json = JSON.parse(File.read(f))
      lines << "  <li><a href=\"StructureDefinition-#{json['id']}.html\">#{json['id']}</li>" 
    end
    lines << '</ul>'
    File.open(File.join(includes_dir, 'complex-data-types-list.html'), 'w+') { |f| f.puts lines.join("\n") }
  end
  
end


