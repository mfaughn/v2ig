module V2FHIR
  puts "I AM LOADED"
  module_function
  
  def escape_adoc(str)
    # str.sub(/^=/, '\=')
    ret = str.sub(/^=/, '{empty}=')
    escape_er7(ret)
  end
  
  def escape_er7(str)
    if str.strip[0] == '|'
      puts Rainbow("Escape ER7: ").springgreen + str
      parts = str.split('^') #str.gsub(/\^/, '\^')
      escaped_str = ''
      parts.each_with_index do |part, i|
        if i.even?
          if i == 0
            escaped_str << part
          else
            escaped_str << '^' + part
          end
        else
          if parts[i+1]
            escaped_str << '\^' + part
          else
            escaped_str << '^' + part
          end
        end
      end        
      return escaped_str
    else
      # puts Rainbow("No ER7: ").maroon + str if str =~ /\|/
      return str
    end
  end
  
  def process_section_item(i, obj, adoc, ignores = [])
    section = obj.is_a?(V2AD::Section) ? obj : obj.section
    section_content = section.content
    item            = section_content[i]
    next_item       = section_content[i+1]
    next_content    = next_item&.content&.first if next_item.respond_to?(:content)
    prev_item       = section_content[i-1]
    prev_content    = prev_item&.content&.first if prev_item.respond_to?(:content)
    insert_break    = true

    return if next_item_is_caption?(item, next_item, section.num)

    case item
    when V2AD::Table
      if ignore_table?(item, ignores)
        unless ignores.any?
          adoc << "[#{item.type}-table]"
          adoc << ''
        end
        return
      end
    
      case item.type
      when :datatype_definition
        adoc << "[datatype-definition-table, #{code}]"
        adoc << '<placeholder for data type table>'
        # puts Rainbow('insert data type definition table').tan
      when :other
        cap = item.caption || item.possible_caption
        unless cap
          puts Rainbow("Table with no caption in #{section.num}").olivedrab
          # pp item
        end      
        adoc << ('.' + cap) if cap
        adoc << item.declaration
        item.rows.each { |row| adoc << row }
      else
        pp item
        raise "Wrong kind of table for a data type entry"
      end
    when V2AD::Paragraph
      item.content.each { |text| adoc << escape_adoc(text) }
    when V2AD::Definition
      raise if item.content.size > 1
      defn = item.content.first.sub(/^\s*\*?[Dd]efinition:?\*?:?\s*/, '')
      # puts Rainbow('Definition: ').cyan + defn
      adoc << "[datatype-definition]"
      adoc << escape_adoc(defn)
    when V2AD::Note
      ic = item.content
      if item.content.size > 1
        puts Rainbow("Multi-line NOTE in #{obj.section.num}").tan
        puts ic
      end
      note0 = ic.first.sub(/^\s*\*?[Nn]ote:?\*?:?\s*/, '')
      # puts Rainbow('Note: ').cyan + note
      adoc << "[NOTE]"
      adoc << escape_adoc(note0)
      ic[1..-1].each { |c| adoc << escape_adoc(c) }
    when V2AD::Example
      raise if item.content.size > 1
      ex = item.content.first.sub(/^\s*[Ee]xample\s*:?\s*/, '').strip
      if ex.empty?
        if next_item.is_a?(V2AD::ER7Snippet) || next_item.is_a?(V2AD::ER7)
          adoc << '[er7-example]'
          insert_break = false
        elsif next_item.is_a?(V2AD::Paragraph)
          if next_content =~ /^\|/
            # This happens because I didn't catch all instances of ER7 in initial parsing...
            adoc << '[er7-example]'
            insert_break = false
          else
            adoc << '[example]'
            insert_break = false
          end
        else
          puts "ITEM:"
          pp item
          puts "NEXT ITEM:"
          pp next_item
          raise "Empty example text in #{obj.section.num} and next item is a #{next_item.class}"
        end
      else
        puts Rainbow('Example: ').cyan + ex
        adoc << '[example]'
        adoc << escape_adoc(ex)
      end
    when V2AD::ER7
      ic = item.content
      ic.each_with_index do |er7, j|
      # puts Rainbow('ER7Snippet: ').cyan + er7
        if j == 0 && section_content[i-1].is_a?(V2AD::Example)
          adoc << escape_er7(er7)
        else
          adoc << '[er7]'
          adoc << escape_er7(er7)
        end
        adoc << '' if ic[i+1] 
      end
    when V2AD::ER7Snippet
      raise if item.content.size > 1
      er7 = item.content.first
      # puts Rainbow('ER7Snippet: ').cyan + er7
      if section_content[i-1].is_a?(V2AD::Example)
        adoc << escape_er7(er7)
      else
        adoc << '[er7-snippet]'
        adoc << escape_er7(er7)
      end
    when V2AD::Image
      raise if item.content.size > 1
      filename = item.content.first.sub(/^image::?/, '').sub(/\[.*$/, '')
      adoc << "image::#{filename}[]"    
    else
      pp item
      raise "unknown item type"
    end
    adoc << '' if insert_break
  end

  def ignore_table?(table, ignores = [])
    if ignores.any?
      ignores.include?(table.type)
    else
      table.type.to_s =~ /definition|ack_chor|message_structure/
    end
  end
  
  def next_item_is_caption?(item, next_item, clause)
    return false if item.is_a?(V2AD::Table)
    return false unless next_item.is_a?(V2AD::Table)
    ic = item.content
    pc = next_item.possible_caption
    if ic.size > 1 && pc
      pp item
      raise "Item preceeding Table with possible_caption in #{clause} has multiple content items."
    end
    ic.first == pc
  end

  def block_level(str)
    str.count('.') + 1
  end
  
end
