require 'rainbow'
# require 'tempfile'
require 'open3'
# require 'fileutils'

module ConvertAdoc2Markdown
  
  module_function

  # Install downdoc first. https://github.com/opendevise/downdoc
  def convert_with_downdoc(adoc)
    cmd = "npx downdoc #{adoc}"
    stdout, stderr, status = Open3.capture3(cmd)
    unless status.success?
      puts Rainbow(adoc).orange
      puts stdout if stdout.to_s.strip[0]
      puts stderr if stderr.to_s.strip[0]
    end
  end
  
  # Install downdoc first. https://github.com/opendevise/downdoc
  def convert_with_asciidoctor(adoc)
    cmd = "asciidoctor #{adoc}"
    stdout, stderr, status = Open3.capture3(cmd)
    unless status.success?
      puts Rainbow(adoc).orange
      puts stdout if stdout.to_s.strip[0]
      puts stderr if stderr.to_s.strip[0]
    end
  end
  
  def convert_data_type_adoc2md
    dir = File.expand_path('../data_structures/data_types', __dir__)
    files = Dir.glob(File.join(dir, "**/*.adoc"))
    files.each { |f| next unless File.file?(f); convert_with_downdoc(f) }
  end
  
  def convert_data_type_adoc2html
    dir = File.expand_path('../data_structures/data_types', __dir__)
    files = Dir.glob(File.join(dir, "**/*.adoc"))
    files.each { |f| next unless File.file?(f); convert_with_asciidoctor(f) }
  end
  
end

# ConvertAdoc2Markdown.convert_data_type_adoc2md
ConvertAdoc2Markdown.convert_data_type_adoc2html
