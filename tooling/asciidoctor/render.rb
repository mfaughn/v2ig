module WriteAdoc
  module_function
  
  def render(filename)
    str = File.read(filename)
    # debug_file_str(str)
    
    local_html_file       = local_outputify(filename)
    destination_html_file = destination_outputify(filename)
    
    # template_dir = File.expand_path('templates', __dir__)
    
    doc_attributes = {
      'docinfo'    => 'shared',
      'docinfodir' => git_dir,
      'stylesdir'  => '/css',
      'stylesheet' => 'v2.css',
      'linkcss'    => '',
      'copycss!'   => '',
      'nothing'    => '',     
    }
    
    # Asciidoctor.convert(str, doctype: :book, mkdirs:true, to_file: local_html_file, safe: :unsafe, attributes: doc_attributes, template_dirs: [template_dir], template_engine: 'haml', linkcss: true, copycss: true)

    Asciidoctor.convert(str,
                        doctype: :book, 
                        mkdirs:true, 
                        to_file: local_html_file, 
                        safe: :unsafe,
                        attributes: doc_attributes, 
                        # template_dirs: [template_dir],
                        # template_engine: 'haml',
                        # nothing: nil
                        )

    
    FileUtils.cp(local_html_file, destination_html_file)
    # Asciidoctor.convert(str, doctype: :book, mkdirs:true, to_file: html_file, safe: :unsafe, attributes: { })
    
    # puts "#{filename} --> #{destination_html_file}"
    # Asciidoctor.convert_file(filename, doctype: :book, mkdirs:true, to_file: html_file, safe: :unsafe, attributes: { })
  end
  
  def debug_file_str(str)
    lines = str.split("\n")
    lines.each { |l| puts Rainbow(l).orange if l =~ /\^/ }
  end
  
end