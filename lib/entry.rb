
class Entry
  def initialize(key, value)
    @key  = key
    @value = value
    @comment = nil
    @tag = nil
    @description = nil
  end
  
  def initialize_copy(original)
    puts "clone"
    @key = @key.clone
    @value = @value.clone
    @comment = @comment.clone
    @description = @description.clone
    @tag = @tag.clone
  end

  def key
    @key
  end
  
  def value
    @value
  end
  
  def tag
    @tag
  end
  
  def comment
    @comment
  end

  def description
    @description
  end

  def tag=(value)
    @tag = value
  end

  def description=(value)
    @description = value
  end
  
  def comment=(value)
    @comment = value
  end
  
  def value=(value)
    @value = value
  end
  
  def to_s
    result = ""
    if (@description)
      result += description
    end
    result += "#@key = #@value;"
    
    comment = false;
    if (@tag) 
      result << " // " << @tag
      comment = true
    end

    if (@comment && @comment.length > 0) 
      if (!comment) 
        result << " //"
      end
      result << " " << @comment
    end
    
    result
  end
  
  ENTRY_PATTERN = Regexp.new(/(\".*?\")\s*=\s*(\".*\");/)
  TAG_PATTERN = Regexp.new(/(@\w*)/)
  
  def Entry.parse(line)
    match = ENTRY_PATTERN.match(line)
      if (match)
        entry = Entry.new(match[1],match[2])
        comment =  line[match.end(2)+1, line.length].strip
        if (comment.start_with? "//")
          tagMatch = TAG_PATTERN.match(comment)
          if (tagMatch) 
            entry.tag = tagMatch[1]
            entry.comment = comment[tagMatch.end(1), comment.length].strip
          end
            
        end
        return  entry
      end
      return nil
  end
  
  
  def Entry.isCommentStart(line)
    if (line.strip.start_with?("/*"))
      return true
    end
    return false
  end
  
  def Entry.isCommendEnd(line)
    if (line.strip.end_with?("*/"))
      return true
    end
    return false
  end
  
  
  def Entry.readFile(filename, processComments=true)
    #puts "read file '#{filename}'"
    file = File.new(filename, "r:UTF-8")
  
    result = Hash.new
    
    comment = nil
    description = nil

    while (line = file.gets)
      
      if (comment) 
        # see if multiline comment is at end
        comment += line
        if (Entry.isCommendEnd(line)) 
          description = comment
          comment = nil
        end
      elsif (Entry.isCommentStart(line) && Entry.isCommendEnd(line))
        # comment is only one line
        description = line
      elsif (Entry.isCommentStart(line))
        # comment is multiline 
        comment = line
      else
        #puts "no comment so parse: #{line}" 
        entry = Entry.parse(line)
        if (entry != nil) 
          if (processComments)
            entry.description = description;
          end
          description = nil;
          result[entry.key] = entry
          
        end
      end
      
    end
    file.close()
    return result
  end
end