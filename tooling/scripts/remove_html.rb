def remove_html(dir, dry_run = false)
  files = Dir.glob(File.join(dir, '**/*.html'))
  if dry_run
    puts files
  else 
    files.each { |f| FileUtils.rm(f) }
  end
end

dir = File.expand_path('../sections', __dir__)
remove_html(dir)
