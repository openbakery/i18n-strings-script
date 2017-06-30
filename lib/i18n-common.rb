
$languagePathExtension = '.lproj'

def languagesFilesFor(stringsFile)
  return languagesFilesFor(stringsFile, false)
end

def languagesFilesFor(stringsFile, includeSelf)
  
  path = nil
  
  Dir.chdir(File.dirname(stringsFile)) do
    Dir.chdir("..") do
      path = Dir.pwd
    end
  end

  $defaultLanguage = File.basename(File.dirname(stringsFile), $languagePathExtension)

  result = Hash.new

  Dir.chdir(path) do
    Dir['*' + $languagePathExtension].each { |item| 
      language = File.basename(item, $languagePathExtension)
      if (language != $defaultLanguage || includeSelf)
        result[language] = stringFileForLanguage(path, stringsFile, language)
      end
    }
  end
  
  return result
end


def stringFileForLanguage(path, stringsFile, language)
  result =  path + File::SEPARATOR + language + $languagePathExtension + File::SEPARATOR + File.basename(stringsFile)
  #puts "path for language #{language}: #{result}"
  if (File.exists?(result))
    return result
  end
  return nil
end