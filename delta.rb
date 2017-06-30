#!/usr/bin/env ruby
# coding: utf-8

#TEXTS_NOT_TRANSLATED = "- Number texts not translated: %d\n"
#NEW_TEXTS = "  - %d new texts\n"
#MISSING_TRANSLATIONS = "  - %d missing translation\n"
#LANGUAGE = "Language: %s\n"

require_relative 'lib/entry.rb'
require_relative 'lib/common.rb'

TEXTS_NOT_TRANSLATED = "- Anzahl nicht übersetzter Texte: %d\n"
NEW_TEXTS = "  - %d Neue Texte\n"
MISSING_TRANSLATIONS = "  - %d fehlende Übersetzungen\n"
LANGUAGE = "Sprache: %s\n"


if (RUBY_VERSION.to_f < 1.9) 
  puts "This script works only with Ruby 1.9.x or greater. You are using #{RUBY_VERSION}" 
  exit
end





def delta(defaultLanguageData, compareLanguageData)
  result = defaultLanguageData.clone
  missingKeys = Hash.new
  
  newEntry = 0
  defaultLanguageData.each do |defaultKey, defaultEntry|
    
    if (compareLanguageData.key?(defaultKey))

      compareEntry = compareLanguageData[defaultKey]
      #print "#{compareValue} == #{defaultEntry}: "
      
      if (compareEntry.tag == "@again")
        result[defaultKey] = compareEntry
        # translate again, so keep it
      elsif (compareEntry != nil && defaultEntry.value != compareEntry.value)
        result.delete defaultKey
        #puts "REMOVE"
      elsif (compareEntry.tag == "@translated")
        result.delete defaultKey
      elsif (compareEntry.tag == "@new")
        result[defaultKey] = compareEntry
        newEntry = newEntry + 1
      else
        defaultEntry.tag = compareEntry.tag
        defaultEntry.comment = compareEntry.comment
        
        #puts "KEEP"
      end

    else
      puts "missing: #{defaultEntry.key} = #{defaultEntry.value};"
      missingKeys[defaultKey] = defaultEntry;
    end
    
  end

  if (result.length > 0)
    printf TEXTS_NOT_TRANSLATED, result.length
  else 
    puts "Ok"
  end
  
  #TEXTS_NOT_TRANSLATED = "- Number texts not translated: %d"
  #NEW_TEXTS = "  - %d new texts"
  #MISSING_TRANSLATIONS = "  - %d missing translation";
  
  if (missingKeys.length > 0 || newEntry > 0)
    #puts "  - Number texts not translated: #{result.length} (#{missingKeys.length} new/#{result.length-missingKeys.length} not translated)";
    printf NEW_TEXTS, missingKeys.length + newEntry
    printf MISSING_TRANSLATIONS, result.length-missingKeys.length
    #missingKeys.each do |defaultKey, defaultEntry| 
    #  puts defaultKey + " = " + defaultEntry + ";";
    #end
  end
  
  
  return result;
end


if (ARGV.length < 1)
  puts "Usage export.rb <path>"
  puts "e.g export.rb Resource/en.proj/Localizable.strings"
  exit
end

$stringsFile = ARGV[0];

Dir.chdir(File.dirname($stringsFile)) do
  Dir.chdir("..") do
    $path = Dir.pwd
  end
end

$defaultLanguage = File.basename(File.dirname($stringsFile), $languagePathExtension)

#puts "path: #{$path}"
#puts "defaultLanguage: #{$defaultLanguage}"
#puts "stringsFile: #{$stringsFile}"
#puts "Examing path #{$path}"

languages = Array.new
Dir.chdir($path) do
  Dir['*' + $languagePathExtension].each { |item| 
    language = File.basename(item, $languagePathExtension)
    if (language != $defaultLanguage)
      languages << language
    end
  }
end

#languages = ['fr']

defaultLanguageData = Entry.readFile($stringsFile)


languages.each{|language|

  printf LANGUAGE, language

  compareLanguageData = Entry.readFile(stringFileForLanguage(language))

  deltaResult = delta(defaultLanguageData, compareLanguageData)

  outputFilename = File.basename($stringsFile, File.extname($stringsFile)) + "_" + language + '.txt'#
  if (deltaResult.size > 0) 
    outputFile = File.new(outputFilename, "w:UTF-8")
    deltaResult.each do |key, value| 
      outputFile.puts "#{value}"
    end
    outputFile.close()
    #puts "Stored to #{outputFilename}: #{deltaResult.size} Entries"
  else 
    #puts "No Delta for Language #{language}"
  end

  puts "\n"

}

