require_relative 'helpers'

class CaretPreprocessor < Asciidoctor::Extensions::Preprocessor
  include V2AsciidocterProcessorHelpers
  
  def process(document, reader)
    lines = reader.lines # get raw lines
    lines = lines.each do |line|
      # puts line if line =~ /\^/ && has_er7?(line)
      if line =~ /\^/ && (has_er7?(line) || has_message_identifier?(line))
        # puts Rainbow(line).cornflower
        line.gsub!('^', '&#x5e;')
        # puts Rainbow(line).lime
      end
    end
    # counter = 1
    # lines.each do |l|
    #   puts counter.to_s.rjust(3) + Rainbow(" #{l}").orange
    #   counter += 1
    # end
    # puts
    reader
  end
  
end
