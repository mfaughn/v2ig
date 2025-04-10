require_relative 'build'
path = ARGV[0]



def make_html(dir, dry_run = false)
  doc_attributes = {
    # 'docinfo'    => 'shared',
    # 'docinfodir' => git_dir,
    # 'stylesdir'  => '/css',
    # 'stylesheet' => 'v2.css',
    # 'linkcss'    => '',
    # 'copycss!'   => '',
    'nothing'    => ''
  }
  files = Dir.glob(File.join(dir, '**/*.adoc'))
  if dry_run
    puts files
  else 
    files.each do |f|
      # puts f
      Asciidoctor.convert_file(f,
                               doctype: :book, 
                               mkdirs:true, 
                               safe: :unsafe,
                               attributes: doc_attributes
                              )
    end
  end
end
# puts Dir.pwd
dir = File.expand_path('../../website/domains', __dir__)
# dir = File.expand_path('../../website/domains/erp/lab_automation', __dir__)
make_html(dir)#, true)
