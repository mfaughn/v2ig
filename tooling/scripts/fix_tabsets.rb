require 'rainbow'
require 'fileutils'
def fix_tabsets(dir, dry_run = false)
  dirs = Dir.glob(File.join(dir, '**/technical_specs'))
  dirs.each do |dir|
    # puts Rainbow(dir).green
    files = Dir.glob(File.join(dir, '*.adoc'))
    files.each do |file|
      bn = File.basename(file)
      # puts Rainbow(bn).cyan
      next if ['Q11.adoc', 'Q13.adoc', 'Q15.adoc'].include?(bn)
      lines = File.readlines(file)
      tabsets = lines.count { |l| l =~ /\[tabset\]/ }
      if tabsets > 1 && bn !~ /M0..adoc/
        puts Rainbow("#{file} has multiple tabsets").orange
        next
      end
      if tabsets < 1
        puts Rainbow("#{file} has no tabsets").red
        next
      end
      event_id = lines[2].slice(/(?<=Event )\w\w\w/)
      event_ids = lines[2].slice(/(?<=Events )\w\w\w and \w\w\w/)&.split(/\s+and\s+/)&.map(&:strip) unless event_id
      raise if event_id == /var/i || event_ids&.first =~ /var/i
      unless event_id || event_ids
        puts lines
        raise "No event id in #{lines[2]} from #{file}" 
      end
      puts Rainbow(event_id).springgreen + " #{file}" if event_id
      puts Rainbow(event_ids).orangered + " #{file}" if event_ids
      if event_id
        content = File.read(file).sub(/\[tabset\]/, "[tabset]\n#{event_id}")
      end
      if event_ids
        content = File.read(file).sub(/\[tabset\]/, "[tabset]\n#{event_ids.first}\n#{event_ids.last}")
        # puts content if dry_run
      end
      # puts File.basename(file)
      if dry_run
        # next
        puts content
        puts
      else
        raise
        File.open(file, 'w') { |f| f.puts content }
      end
      
    end
  end
  return
end

dir = File.expand_path('../domains', __dir__)
fix_tabsets(dir)#, true)
