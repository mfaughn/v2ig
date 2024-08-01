require 'asciidoctor'

module V2AsciiDoctor


# Asciidoctor.convert(str, doctype: :book, mkdirs:true, to_file: local_html_file, safe: :unsafe, attributes: doc_attributes, template_dirs: [template_dir], template_engine: 'haml', linkcss: true, copycss: true)

  def self.go
    files = Dir['**/*.adoc']
    files.each do |file|
      # puts file
      convert(file)
    end
  end
      
  
  def self.convert(path)

    doc_attributes = {
      'docinfo'    => 'shared',
      'imagesdir'  => Dir.pwd,
      # 'docinfodir' => git_dir,
      # 'stylesdir'  => '/css',
      # 'stylesheet' => 'v2.css',
      # 'linkcss'    => '',
      # 'copycss!'   => '',
      'nothing'    => '',     
    }

    Asciidoctor.convert_file(path,
                        doctype: :book, 
                        mkdirs:true, 
                        # to_file: local_html_file, 
                        safe: :unsafe,
                        attributes: doc_attributes, 
                        # template_dirs: [template_dir], 
                        # template_engine: 'haml', 
                        nothing: nil
                        )
  end
end
V2AsciiDoctor.go
