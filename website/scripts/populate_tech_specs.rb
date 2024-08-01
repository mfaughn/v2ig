require_relative 'csv'
load File.join(__dir__, 'process_sections.rb')

module V2FHIR
  module PopulateTechSpecs
    
    module_function
    
    def do
      csv_source = V2FHIR::Structure.full
      sections_registry = V2AD.v2.sections
      # reset_slurp(:testing)
  
      puts Rainbow('Populating Tech Specs').cyan
      page_registry = {}
      last_page = 'not a page'
      path = []

      csv = CSV.read(csv_source)
      headers = csv.shift
      # headers.each_with_index { |h,i| puts "#{i} - #{h}"}
      # 0 - First level - Level1
      # 1 - Domain/Workflow/... - Level2
      # 2 - Second Level - Level3
      # 3 - Third Level - Level4
      # 4 - V2 Section
      # 5 - V2 Section Names
      # 6 - v2+ HTML Page - Level5
      # 7 - v2+ Group Type
      # 8 - v2+ Group Section
      # 9 - Comments
      root = File.expand_path('..', __dir__)
      
      csv.each_with_index do |row, index|
        next if row.compact.empty?
        row[0..3].each_with_index do |cell, i|
          if cell.to_s.strip.[](0)
            cell = 'domains' if cell =~ /Domain Messaging View/
            cell = 'medical_records' if cell == 'Medical Records (consider renaming to Document Management)'
            path[i] = cell.strip.gsub(/\s+/, '_').downcase.strip
            path = path[0..i]
            break
          end
        end
        next unless path.last =~ /technical_spec/
        next if path.compact.empty?
        section_nums = row[4]&.gsub('a.', 'A.')
        next unless section_nums
        
        v2_section_name = row[5]
        next unless v2_section_name
        page_title = row[6]
        page_basename = page_title.sub(/^\s*Message\s*-\s*/, '').slice(/^[A-Z0-9\/]{3,}/)&.gsub('/', '_')
        page_basename ||= page_title.sub(/^\s*Message\s*-\s*/, '').gsub(/\/|\s+/, '_')
        puts Rainbow(page_title).orchid + ' --> ' + page_basename.to_s  unless page_basename
        dest_file = File.join(root, path, page_basename)
        
        errors = {}
        included_sections = {}
        excluded_sections = {}
        minuses = []
        
        # These minuses are irrelevant since they all appear with an included section that already doesn't include them (because the included section is not suffixed with a '+')
        minus = section_nums.slice(/\(\s*minus.*\)/)
        if minus
          minuses = minus.sub(/\(\s*minus/, '').strip.sub(/\)/, '').strip.split(/;|and/).map(&:strip)
          # puts Rainbow(minuses.inspect).springgreen
          raise "Bad minuses #{minuses}" if minuses.any? { |str| str =~ /\+/ }
          section_nums = section_nums.sub(minus, '')
          # puts Rainbow(section_nums).teal
        end
        
        nums = section_nums.split(';').map(&:strip)
        nums.each do |num|
          if num =~ /^\d+A?(\.\d+)*$/
            included_sections[num] = {}
          else
            if num =~ /^\d+A?(\.\d+)*\+$/
              root_section = num.sub(/\+$/, '')
              matching_sections = sections_registry.keys.select { |k| k =~ /^#{root_section}/ }
              matching_sections.sort.each { |ms| included_sections[ms] = {} }
            else
              if num == '4.4.19!'
                num = '4.4.19'
                included_sections[num] = {reuse:true}
              else
                errors[:sections] ||= []
                errors[:sections] << num
                puts Rainbow(num).red
                puts "Excel #{index + 2}: #{row}"
                raise 'crap'
              end
            end
          end
        end
        
        # puts Rainbow("#{index} - #{row.inspect}").tan
        
        if last_page == dest_file
          # Check that sections are the same
          last_page = dest_file
        else
          if page_registry[dest_file]
            page_registry[dest_file][:errors][:page_collisions] ||= []
            page_registry[dest_file][:errors][:page_collisions] << {
              index:index + 2,
              row:row,
              title:page_title,
              v2section_name:v2_section_name,
              included_sections:included_sections.keys,
              basename:page_basename              
            }
            next
          else
            page_registry[dest_file] = {
              index:index + 2,
              row:row,
              title:page_title,
              v2section_name:v2_section_name,
              included_sections:included_sections.keys,
              basename:page_basename,
              errors:errors
            }
            last_page = dest_file
          end
        end
        

        # Try to get adoc that was already prepared
        #
        # ch = section_num.split('.').first
        # root = File.expand_path('..', __dir__)
        # file = File.join(root, 'sections', ch, section_num + '.adoc')
        # if File.exist?(file)
        #   puts Rainbow(file).green
        # else
        #   puts Rainbow(file).orange
        # end
        
        # puts Rainbow(path.join('/')).tan + '/' + section_num
        # puts Rainbow(file).tan
        # puts Rainbow(path.join('/')).palevioletred + ' ' + row[5..8].inspect
        
      end # csv.each_with_index
      
      # pp page_registry
      page_registry.each do |dest_file, data|
        # puts dest_file
        data[:included_sections].each do |num|
          found = sections_registry[num]
          if found
            section = found[:obj]
            adoc = ["= #{data[:title]}"]
            adoc << ":v291_section: #{section.num.inspect}"
            adoc << ":v2_section_name: #{data[:v2section_name].inspect}"
            adoc << ":generated: #{Time.now.rfc2822.inspect}"
            # bl = block_level(section.num)
            adoc << ''
            section_content = section.content
            section_content.each_with_index do |item, i|
              V2FHIR.process_section_item(i, section, adoc)
            end
            File.open(dest_file, 'w+') { |f| f.puts adoc }
          else
            puts Rainbow(num).orange + ' section not found in registry'
          end
          #   # if section
          #   #   puts Rainbow(section_num).green + ' ' + dest_file
          #   # else
          #   #   puts Rainbow(section_num).orange + ' ' + dest_file
          #   # end
          # end
        end
      end
      
      # TODO write this to a file that may be distributed
      page_registry.each do |dest_file, data|
        next unless data[:errors].any?
        pp data
      end
        
    end # def do
    
  end # PopulateTechSpecs
end # V2FHIR
V2FHIR::PopulateTechSpecs.do