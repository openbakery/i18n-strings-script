#!/usr/bin/env ruby

require_relative 'lib/entry.rb'
require_relative 'lib/common.rb'

if (RUBY_VERSION.to_f < 1.9) 
  puts "This script works only with Ruby 1.9.x or greater. You are using #{RUBY_VERSION}" 
  exit
end

if (ARGV.length < 1)
  puts "Usage sord_i18n.rb <strings-file>"
  exit
end

$stringsFile = ARGV[0];


if (!File.exists?($stringsFile)) 
  puts "file #{$stringsFile} does not exist";
  exit
end


#puts importData


#importData.sort_by{|key, value| key.downcase}.map do |key,value|
#  puts "#{value}"
#end




Dir.chdir(File.dirname($stringsFile)) do
  Dir.chdir("..") do
    $path = Dir.pwd
  end
end

$defaultLanguage = File.basename(File.dirname($stringsFile), $languagePathExtension)


languages = Array.new
Dir.chdir($path) do
  Dir['*' + $languagePathExtension].each { |item| 
    language = File.basename(item, $languagePathExtension)
    languages << language
  }
end


languages.each{|language|


  languageFile = stringFileForLanguage(language)
  puts "Sorting values in: #{languageFile}"
  
  importData = Entry.readFile(languageFile)
  
  outputFile = File.new(languageFile, "w:UTF-8")

  importData.sort_by{|key, value| key.downcase}.map do |key,value|
    outputFile.puts "#{value}"
  end

  outputFile.close()

}


