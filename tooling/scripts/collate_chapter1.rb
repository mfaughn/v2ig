#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

Encoding.default_external = Encoding::UTF_8

# Directories
REPO_ROOT = File.expand_path('../..', __dir__)
CHAPTER_1_DIR = File.join(REPO_ROOT, 'original_content', 'sections', '1')
WEBSITE_DIR = File.join(REPO_ROOT, 'website')
OUTPUT_FILE = File.join(WEBSITE_DIR, 'introduction.adoc')

def parse_section_number(filename)
  # Extract section number from filename like "1.2.adoc" or "1.7.5.1.adoc"
  # Returns array of integers for proper sorting: [1, 2] or [1, 7, 5, 1]
  basename = File.basename(filename, '.adoc')
  parts = basename.split('.').map(&:to_i)
  parts
end

def sort_files(files)
  # Sort files by their section number parts
  files.sort_by { |f| parse_section_number(f) }
end

def collate_chapter_files
  puts "=" * 70
  puts "Collating Chapter 1 files into introduction.adoc"
  puts "=" * 70
  puts

  # Get all .adoc files from chapter 1
  files = Dir.glob(File.join(CHAPTER_1_DIR, '*.adoc'))

  if files.empty?
    puts "ERROR: No ADOC files found in #{CHAPTER_1_DIR}"
    exit 1
  end

  puts "Found #{files.length} files in chapter 1"

  # Sort files by section number
  sorted_files = sort_files(files)

  # Start building the combined content
  content = []
  content << "= Introduction"
  content << ""

  # Read and append each file
  sorted_files.each do |file|
    section_num = File.basename(file, '.adoc')
    puts "  Adding section #{section_num}..."

    file_content = File.read(file, encoding: 'UTF-8')

    # Add the file content
    content << file_content
    content << ""  # Add blank line between sections
  end

  # Join all content
  final_content = content.join("\n")

  # Write to output file
  File.write(OUTPUT_FILE, final_content, encoding: 'UTF-8')

  puts
  puts "=" * 70
  puts "Successfully created: #{OUTPUT_FILE}"
  puts "Total sections combined: #{sorted_files.length}"
  puts "Output size: #{final_content.length} bytes"
  puts "=" * 70
end

# Run the collation
collate_chapter_files
