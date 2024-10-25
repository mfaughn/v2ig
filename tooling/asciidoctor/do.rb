require_relative 'build'
path = ARGV[0]

doc_attributes = {
  # 'docinfo'    => 'shared',
  # 'docinfodir' => git_dir,
  # 'stylesdir'  => '/css',
  # 'stylesheet' => 'v2.css',
  # 'linkcss'    => '',
  # 'copycss!'   => '',
  'nothing'    => ''
}

if path
  Asciidoctor.convert_file(path,
                           doctype: :book, 
                           mkdirs:true, 
                           safe: :unsafe,
                           attributes: doc_attributes
                          )
end
