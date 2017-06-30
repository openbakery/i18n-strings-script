
$languagePathExtension = '.lproj'

def stringFileForLanguage(language)
  result =  $path + File::SEPARATOR + language + $languagePathExtension + File::SEPARATOR + File.basename($stringsFile)
  #puts "path for language #{language}: #{result}"
  if (File.exists?(result))
    return result
  end
  return nil
end


class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end