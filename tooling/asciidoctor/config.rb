require 'rainbow'
Dir.glob(File.join(__dir__, 'processors', '**', '*.rb'), &method(:load))

Asciidoctor::Extensions.register do
  preprocessor CaretPreprocessor # changes caret symbol to HTML entity
  block ER7BlockProcessor
  block TabSetBlockProcessor
end

# Asciidoctor::Stylesheets.instance.write_primary_stylesheet '.'
