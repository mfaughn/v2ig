#!/usr/bin/env ruby
# encoding: UTF-8

# Script to convert AsciiDoc content to GFM Markdown (no inline HTML)
# This is used to prepare content for injection into FHIR StructureDefinition JSON files

# Force UTF-8 encoding
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

class AsciiDocToMarkdownConverter

  # Main conversion method for files
  def convert_file(adoc_file_path)
    content = File.read(adoc_file_path, encoding: 'UTF-8')
    extract_and_convert_content(content)
  end

  # Extract the actual content (skip headers and metadata) and convert
  def extract_and_convert_content(adoc_content)
    lines = adoc_content.lines.map(&:rstrip)

    # For main files: = heading, then :attributes:, then content
    # For component files: == heading, then :attributes:, then content
    # We want to skip all of that and get just the content

    content_start = 0
    in_metadata = false

    lines.each_with_index do |line, idx|
      # Check if this is a heading line
      if line.match?(/^=+\s/)
        in_metadata = true
        next
      end

      # Skip attribute lines (starting with :)
      if line.start_with?(':')
        in_metadata = true
        next
      end

      # Skip empty lines if we're still in metadata section
      if line.strip.empty? && in_metadata
        next
      end

      # If we get here and we've seen metadata, this is the start of content
      if in_metadata || idx == 0
        content_start = idx
        break
      end
    end

    # Extract content lines
    content_lines = lines[content_start..-1]

    # Convert to markdown
    convert_content(content_lines.join("\n"))
  end

  # Convert AsciiDoc content to GFM Markdown
  def convert_content(adoc_text)
    # Remove include directives (we're processing individual files)
    adoc_text = adoc_text.gsub(/^include::.*\[\].*$/, '')

    # Convert block markers
    adoc_text = convert_blocks(adoc_text)

    # Convert inline formatting
    adoc_text = convert_inline_formatting(adoc_text)

    # Convert tables
    adoc_text = convert_tables(adoc_text)

    # Clean up
    adoc_text = cleanup(adoc_text)

    adoc_text.strip
  end

  private

  def convert_blocks(text)
    # Convert NOTE blocks to blockquotes
    text = text.gsub(/^\[NOTE\]\s*\n((?:(?!\n\n|\[).+\n?)+)/m) do
      content = $1.strip
      "> **NOTE:** #{content.gsub("\n", "\n> ")}"
    end

    # Convert example blocks to code blocks or blockquotes
    text = text.gsub(/^\[example\]\s*\n((?:(?!\n\n|\[).+\n?)+)/m) do
      content = $1.strip
      "> **Example:**\n> \n> #{content.gsub("\n", "\n> ")}"
    end

    # Convert [er7] blocks (HL7 encoding examples) to code blocks
    text = text.gsub(/^\[er7\]\s*\n((?:(?!\n\n|\[).+\n?)+)/m) do
      content = $1.strip
      "```\n#{content}\n```"
    end

    # Remove [datatype-definition] markers (just keep the content)
    text = text.gsub(/^\[datatype-definition\]\s*\n/, '')

    # Remove anchors like [#anchor_name .class]
    text = text.gsub(/^\[#[^\]]+\]/, '')

    text
  end

  def convert_inline_formatting(text)
    # Handle {empty} (used for spacing/numbering in AsciiDoc)
    text = text.gsub(/\{empty\}/, '')

    # Convert bold: *text* -> **text** (but be careful not to double-convert)
    # First, protect **text** that's already markdown
    protected_bold = []
    text.gsub(/\*\*([^*]+)\*\*/) do
      protected_bold << $1
      "<<<BOLD#{protected_bold.length - 1}>>>"
    end

    # Now convert single * to **
    text = text.gsub(/\*([^*\n]+)\*/, '**\1**')

    # Restore protected bold
    protected_bold.each_with_index do |content, idx|
      text = text.sub("<<<BOLD#{idx}>>>", "**#{content}**")
    end

    # Convert italic/emphasis: _text_ -> *text*
    text = text.gsub(/_([^_\n]+)_/, '*\1*')

    # Convert file:// links (just extract the text part since they're local refs)
    text = text.gsub(/file:\/\/[^\[]*\[([^\]]+)\]/, '\1')

    # Convert internal anchor links: link:#anchor[text] -> [text](#anchor)
    text = text.gsub(/link:#([^\[]+)\[([^\]]+)\]/, '[\2](#\1)')

    # Convert xref: <<anchor,text>> -> [text](#anchor)
    text = text.gsub(/<<([^,\>]+),([^>]+)>>/, '[\2](#\1)')
    text = text.gsub(/<<([^>]+)>>/, '[\1](#\1)')

    # Handle line breaks: + at end of line -> two spaces (MD line break)
    text = text.gsub(/ \+$/, '  ')

    text
  end

  def convert_tables(text)
    # Convert AsciiDoc tables to GFM tables
    text.gsub(/^\[width="[^"]*",cols="[^"]*"[^\]]*\]\s*\n\|===\s*\n(.*?)\n\|===\s*$/m) do
      table_content = $1

      lines = table_content.split("\n").reject { |l| l.strip.empty? }
      return "" if lines.empty?

      # Detect if first row is header (starts with |* or has only header-like content)
      has_header = lines[0].match?(/^\|?\*.*\*/) || lines[0].match?(/^\|[A-Z]/)

      rows = []
      current_row = []

      lines.each do |line|
        # Each line starting with | is a new row (or continuation)
        cells = line.split('|').reject { |c| c.strip.empty? }.map do |cell|
          # Remove ** from headers, convert inline formatting
          cell = convert_inline_formatting(cell.strip)
          cell.gsub(/^\*\*|\*\*$/, '') # Remove bold markers from table headers
        end

        if cells.any?
          if line.start_with?('|') && current_row.any?
            # New row
            rows << current_row
            current_row = cells
          else
            # Continuation of previous row or first row
            current_row.concat(cells)
          end
        end
      end

      rows << current_row if current_row.any?

      return "" if rows.empty?

      # Build GFM table
      md_table = []

      if has_header && rows.length > 1
        # First row is header
        header = rows[0]
        md_table << "| #{header.join(' | ')} |"
        md_table << "| #{header.map { '---' }.join(' | ')} |"

        # Rest are body rows
        rows[1..-1].each do |row|
          # Pad row to match header length
          row = row + [''] * (header.length - row.length) if row.length < header.length
          md_table << "| #{row[0...header.length].join(' | ')} |"
        end
      else
        # No header, all rows are data
        max_cols = rows.map(&:length).max
        rows.each do |row|
          row = row + [''] * (max_cols - row.length) if row.length < max_cols
          md_table << "| #{row.join(' | ')} |"
        end
      end

      md_table.join("\n")
    end
  end

  def cleanup(text)
    # Remove table titles (lines starting with .)
    text = text.gsub(/^\.[A-Z].*$/, '')

    # Clean up multiple blank lines
    text = text.gsub(/\n{3,}/, "\n\n")

    # Trim
    text.strip
  end
end

# CLI interface
if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: #{$0} <asciidoc-file>"
    exit 1
  end

  converter = AsciiDocToMarkdownConverter.new
  result = converter.convert_file(ARGV[0])
  puts result
end
