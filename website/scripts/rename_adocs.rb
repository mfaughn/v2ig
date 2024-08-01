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

dir = File.expand_path('../domains/administration/registration/example_transactions', __dir__)
rename_adocs(dir, true)
