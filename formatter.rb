#!/usr/bin/ruby
 
class Reader
  attr_accessor :path, :file
  def initialize(path)
    @path = path
    @file = File.open(path,'r')
  end

  def getc
    character_code = @file.getc
    if character_code
      character_code.chr 
    else
      false
    end
  end
end

class Cfg
  attr_accessor :spacer, :block_start, :block_end, :new_line_after
  def initialize(spacer, block_start, block_end, new_line_after)
    @spacer = spacer
    @block_start = block_start
    @block_end = block_end
    @new_line_after = new_line_after
    
  end
end

class Formatter
  attr_accessor :reader, :config

  def initialize(reader)
    @config = Cfg.new("  ", "{", "}", ";")
    @reader = reader
  end

  def proceed
    while chr = reader.getc
      yield(chr)
    end
  end
end


reader = Reader.new('./code_samples/oneliner.code')
formatter = Formatter.new(reader)

formatter.proceed do |chr|
  print chr
end

# input = $stdin.read

# counter = 0
# space_sympol = "  "
# line = ""

# end_of_line = false
# should_add_counter = false
# previous_character = nil

# input.split("").each do |character|
#   if end_of_line
#     puts "#{space_sympol*counter}#{line}#{previous_character}"
#     counter = counter + 1 if should_add_counter
#     should_add_counter = false
#     line = ""
#   end

#   end_of_line = false  

#   if character == "{"
#     should_add_counter = true
#     # counter = counter + 1
#   elsif character == "}"
#     counter = counter - 1
#   elsif character == ";"
#     end_of_line = true
#   end

#   unless end_of_line
#     line << character
#   end 
  
#   # puts output
#   previous_character = character
# end
# puts line