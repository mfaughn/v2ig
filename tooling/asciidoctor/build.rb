# NOTES
# - will need to handle deleted files and renaming of files for Git.  This probably means using git status and parsing the output from that
# - handle commits

require 'asciidoctor'
require 'fileutils'
# paths = %w{render write config paths}
paths = %w{render config}
paths.each { |path| load File.expand_path("#{path}.rb", __dir__) }

# Dir.glob(File.join(__dir__, 'templates/html', '**', '*.haml'), &method(:load))


# FIXME this stuff was copied in and is probably not entirely appropriate any longer
module WriteAdoc
  def self.build
    reset # FIXME this is just for use during initial development!
    copy_support_files
    first_level = V2Web::SectionRenderingType.where(value:'Level1').first
    l1 = first_level.sections_with_render_as
    l1.each do |section|
      write_section(section, git_dir, 1)
    end
  end
  
  def self.copy_support_files
    FileUtils.cp(docinfo_file, File.join(git_dir, 'docinfo.html'))  
    FileUtils.cp_r(css_dir,    File.join(absolute_output_dir, 'css'))  
    FileUtils.cp_r(js_dir,     File.join(absolute_output_dir, 'js'))  
    FileUtils.cp_r(images_dir, File.join(absolute_output_dir, 'images'))  
  end
  
  def self.reset
    # FIXME this is just for use during initial development!
    dirs = Dir.glob("#{git_dir}/*")
    FileUtils.rm_r Dir.glob("#{git_dir}/*") if File.exist?(git_dir)
    dirs = Dir.glob("#{absolute_output_dir}/*")
    FileUtils.rm_r Dir.glob("#{absolute_output_dir}/*") if File.exist?(absolute_output_dir)
  end
end
