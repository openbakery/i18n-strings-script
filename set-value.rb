#!/usr/bin/env ruby

require_relative 'lib/entry.rb'
require_relative 'lib/i18n-common.rb'


def setEntry(language, stringFile, entryToInsert) 
  toFileRead = File.new(stringFile, "r:UTF-8")
  enries = Array.new
  
  
  found = false
  
  result = Array.new
  while (line = toFileRead.gets)
    #puts "#{line}"
    
    entry = Entry.parse(line);
    if (entry)
      #puts "#{match[1]} ++ #{match[2]}"
      if (entryToInsert.key == entry.key)
        found = true
        puts "#{language}: Found so set to new value"
        result.push(entryToInsert)      
      else
        result.push(line)
      end

    else
      result.push(line)
    end
  end
  toFileRead.close()

  if (!found)
    puts "#{language}: Not found so create"
    result.push(entryToInsert)
  end


  toFileWrite = File.new(stringFile, "w:UTF-8")
  result.each do |line| 
    toFileWrite.puts line
  end
  toFileWrite.close()
  
  
end

if (RUBY_VERSION.to_f < 1.9) 
  puts "This script works only with Ruby 1.9.x or greater. You are using #{RUBY_VERSION}" 
  exit
end




if (ARGV.length < 3)
  puts "Usage i18n-set-value.rb <toFile> <key> <value>"
  exit
end

toFilename = ARGV[0];


if (!File.exists?(toFilename)) 
  puts "file #{toFilename} does not exist"
  exit
end


entryToInsert = Entry.new("\"#{ARGV[1]}\"", "\"#{ARGV[2]}\"")

#puts entryToInsert
  

puts "Set entry to #{toFilename}: #{entryToInsert}";

languages = languagesFilesFor(toFilename, true)


languages.each do |language, languageFile|
  #puts "#{language}: #{languageFile}"
  setEntry(language, languageFile, entryToInsert)
end

exit


