require_relative 'helpers'

class ER7BlockProcessor < Asciidoctor::Extensions::BlockProcessor
  include V2AsciidocterProcessorHelpers
  
  use_dsl

  named :er7
  on_context :paragraph
  parse_content_as :raw

  def process(parent, reader, attrs)
    er7_lines = []
    reader.lines[0..-2].each do |line|
      if line =~ /\s\+$/
        er7_lines << line
      else
        er7_lines << line + ' +'
      end 
    end
    er7_lines << reader.lines.last
    if attrs["role"]
      puts Rainbow(attrs.inspect).yellow
      attrs["role"] << ' er7' unless attrs["role"].split(/\s/).include?("er7")
    else
      attrs["role"] = 'er7'
    end
    # create_block(parent, :paragraph, er7_lines, attrs)
    create_block(parent, :example, er7_lines, attrs)
  end

end
