require 'rainbow'
require 'fileutils'
def rename_adocs(dir, dry_run = false)
  files = Dir.glob(File.join(dir, '**/*.adoc'))
  files.each_with_index do |f, index|
    title = File.readlines(f).first.sub(/\s*=+\s*/, '').chomp.strip
    new_basename = title.gsub(/\s+|\//, '_').downcase + '.adoc'
    new_filename = File.join(File.dirname(f), new_basename)
    if dry_run
      puts new_basename
      # puts index.to_s + ' ' + new_basename
      # puts File.basename(f) + ":#{title} --> #{new_basename}"
      # FileUtils.mv(f, new_filename, noop:true, verbose:true)
    else 
      FileUtils.mv(f, new_filename, verbose:true)      
    end
  end
end

# dir = File.expand_path('../domains/administration/registration/example_transactions', __dir__)
# rename_adocs(dir, true)

def rename_tech_specs_adocs(dir, dry_run = false)
  # files = Dir.glob(File.join(dir, '**/*.adoc'))
  files = Dir.glob(File.join(dir, '*.adoc'))
  puts Rainbow("Section file:").green
  if files.size == 1
    sf = files.first
  else
    raise "Nooooooo"
  end
  puts Rainbow(sf).mediumspringgreen
  found = false
  xrefs = {}
  counter = 0
  sflines = File.readlines(sf).each do |l|
    if found
      next if l =~ /^\s*$/
      break unless l =~ /^xref/
      x = l.split('technical_specs/').last
      adoc, title = x.split(/(?<=adoc)/)
      puts l unless title
      counter += 1
      xrefs[adoc] = { title:title.delete('[]').chomp, adoc:adoc, index:counter }
    else
      found = true if l =~ /== Technical Specs/
      next
    end
  end
  
  new_xrefs = {}
  tsfiles = Dir.glob(File.join(dir, 'technical_specs', '*.adoc'))
  tsfiles.each do |f|
    fname = File.basename(f)
    entry = xrefs[fname]
    if entry
      # puts entry
      File.readlines(f).each do |l|
        next unless l =~ /:v2_section_name:/
        sn = l.slice(/(?<=").*(?="$)/)
        # puts sn
        if fname =~ /Q\d\d_K\d\d/
          # We should not need to rename this file
          event_id = fname.sub('_', '/').sub('.adoc', '')
          title = entry[:title].gsub(/[-–] (#{event_id} )?/, "- #{event_id} ")
          new_xrefs[entry[:index]] = "xref:technical_specs/#{fname}.adoc[#{title}]"
        else
          event_id = sn.slice(/(?<=[Ee]vent )[A-Z][A-Z0-9][A-Z0-9]/)
          puts Rainbow(sn).teal unless event_id
          renamed  = f.sub(fname, event_id) + '.adoc'
          title    = entry[:title].gsub(/[-–] /, "- #{event_id} ")
          new_xrefs[entry[:index]] = "xref:technical_specs/#{event_id}.adoc[#{title}]"
          FileUtils.mv(f, renamed) unless dry_run
        end
        break
      end
    else
      puts Rainbow(fname).red
    end
  end
  # pp xrefs
  new_xrefs = new_xrefs.to_a.sort_by { |x| x.first }.map(&:last)
  puts new_xrefs.join("\n\n")
end

dir = File.expand_path('../domains/clinical/pharmacy', __dir__)
# rename_tech_specs_adocs(dir, true)
rename_tech_specs_adocs(dir)
