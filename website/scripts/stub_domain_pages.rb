require 'fileutils'
require 'rainbow'
require 'active_support/inflector'

dir = File.expand_path('../domains', __dir__)
# dir = File.expand_path(__dir__)
dirs = Dir.glob("./domains/**")

def subdirs(dir)
  arg = File.join(dir, '**')
  dirs = Dir.glob(arg).select { |d| File.directory?(d) }
end

def desnake_and_titleize(str)
  str.gsub('_', ' ').titleize
end

def stub_dir(dir)
  base = dir.split('/').last
  adoc = File.join(dir, base + '.adoc')
  subs = subdirs(dir)
  if subs.empty?
    tsdir = File.join(dir, 'technical_specs')
    FileUtils.mkdir_p(tsdir)
  end
  techspecs = subs.find { |d| d =~ /technical_specs/ }
  subs = subs.reject { |d| d =~ /technical_specs/ }
  if true #File.exist?(adoc)    
    
  #   puts Rainbow("Already exists: ").webgreen + adoc
  # else
  #   puts Rainbow("Must create:    ").steelblue + adoc
    # create the adoc file
    File.open(adoc, 'w+') do |f|
      lines = []
      title = desnake_and_titleize(base)
      lines << '= ' + title
      lines << ''
      lines << '== Introduction'
      lines << ''
      lines << 'FIXME'
      if subs.any?
        lines << ''
        lines << '== ' + title + ' Subdomains'
        subs.each do |sub|
          sub_dir = sub.split('/').last
          lines << ''
          lines << "xref:#{sub_dir}/#{sub_dir}.adoc[#{desnake_and_titleize(sub_dir)}]"
        end
      end
      if techspecs
        lines << ''
        lines << '== Technical Specs'
        lines << ''
        lines << "xref:technical_specs/SPEC_CODE.adoc[SPEC TITLE]"
      end
      # puts lines
      f.puts lines
    end
  end
  subs.each { |sub| stub_dir(sub) if File.directory?(sub) }
end

stub_dir(dir)