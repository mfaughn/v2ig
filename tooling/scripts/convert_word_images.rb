require 'rainbow'
require 'fileutils'
dirs = Dir['../*extracted-media-*']
dirs.each do |d| 
  path = File.expand_path d
  files = Dir["#{d}/media/*"]
  files.each do |f|
    if f =~ /(png|jpeg)$/
      n = File.basename(f)
      nn = File.expand_path(File.join(d, n))
      puts Rainbow(nn).green
      FileUtils.cp "#{f}", "#{nn}"
    elsif f =~ /mf$/
      puts Rainbow(f).yellow
      # od = File.expand_path("#{d}")
      # puts Rainbow(od).coral
      cmd = "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to png --outdir #{d} #{f}"
      # puts cmd
      system cmd
    else
      puts Rainbow(f).red
    end
  end
end
