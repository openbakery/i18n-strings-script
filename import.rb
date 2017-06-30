#!/usr/bin/env ruby

require_relative 'lib/entry.rb'


if (RUBY_VERSION.to_f < 1.9) 
  puts "This script works only with Ruby 1.9.x or greater. You are using #{RUBY_VERSION}" 
  exit
end

if (ARGV.length < 2)
  puts "Usage import.rb <from> <to>"
  exit
end

fromFilename = ARGV[0];
toFilename = ARGV[1];


if (!File.exists?(fromFilename)) 
  puts "file #{fromFilename} does not exist";
  exit
end

if (!File.exists?(toFilename)) 
  puts "file #{toFilename} does not exist";
  exit
end

puts "Import data from #{fromFilename} to #{toFilename}";

importData = Entry.readFile(fromFilename, false)


toFileRead = File.new(toFilename, "r:UTF-8")
result = Array.new
i = 0

#regex = Regexp.new(/(\".*?\")\s*=\s*(\".*\")/)
#regex = Regexp.new(/(\".*?\")\s*=\s*(\".*?\")/)

while (line = toFileRead.gets)
  #puts "#{line}"

  entry = Entry.parse(line);
  if (entry)
    #puts "#{match[1]} ++ #{match[2]}"
    value = importData[entry.key];
    if (value)
      result.push(value)      
      #puts "changed #{entry}"
      i = i+1
    else
      result.push(line)
    end

  else
    result.push(line)
  end
end
toFileRead.close()


toFileWrite = File.new(toFilename, "w:UTF-8")
result.each do |line| 
  toFileWrite.puts line
end
toFileWrite.close()

puts "#{i} values replaced"
