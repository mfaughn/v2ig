class TabSetBlockProcessor < Asciidoctor::Extensions::BlockProcessor
  use_dsl

  named :"tabset"
  on_context :paragraph
  # parse_content_as :simple
  parse_content_as :raw

  def process(parent, reader, attrs)
    tabset_content = []
    reader.lines.each do |line|
      vals = line.split(/\s/)
      if vals.size < 1
        puts Rainbow("WARNING: tabset block has no content: #{attrs.inspect}")
      end
      tabset_content << "Insert Tabset for messages and acknowledgement choreographies associated with trigger #{vals.size > 1 ? 'events' : 'event'} #{vals.join(', ')}"
    end
    #   type = vals.first
    #   msg  = vals.last
    #   case type
    #   when 'message_structure'
    #     # FIXME do stuff to build whatever needs to be built here
    #     content << "TODO: Insert message structure for #{msg.gsub!('^', '&#x5e;')} here. +"
    #   when 'ack_chor'
    #     # FIXME do stuff to build whatever needs to be built here
    #     content << "TODO: Insert acknowledgement choreography for #{msg.gsub!('^', '&#x5e;')} here. +"
    #   else
    #     raise "Unknown tab type '#{type}' in tabset."
    #   end
    # end
    x = tabset_content.join("\n{empty} +\n")
    attrs["role"] ||= ''
    attrs["role"] << 'message-tabs-FIXME'
    attrs["role"].strip!
    create_paragraph(parent, x, attrs)
  end
  
end
