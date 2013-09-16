#!/usr/bin/ruby
require 'pry'
 
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
  attr_accessor :spacer, :block_start, :block_end, :new_line_symbol
  def initialize(spacer, block_start, block_end, new_line_symbol)
    @spacer = spacer
    @block_start = block_start
    @block_end = block_end
    @new_line_symbol = new_line_symbol
  end
end

class Formatter
  attr_accessor :reader, :sputnik

  def initialize(reader, sputnik)
    @reader = reader
    @sputnik = sputnik
  end

  def proceed
    while chr = reader.getc
      yield(chr)
    end
  end
end

class Pogrom
  def self.puts(str)
    print str
  end
end

class Sputnik
  attr_accessor :word, :line, :cfg, :current_character, :previous_character
  
  def initialize(config)
    @word = ""
    @line = ""
    @cfg = config
    @current_character = nil
    @previous_character = nil
    @counter = 0
    @should_add_counter = false
  end

  def addc(chr)
    @current_character = chr

    analyze!

    if @should_add_counter
      # binding.pry
      @counter = @counter + 1
      @should_add_counter = false
    end

    yield(self)
    
    obsolete!
  end
    
  def expectation
    if end_of_line?
      "#{@cfg.spacer*@counter}#{@line}#{@previous_character};"
      obsolete!
    else
      # "_"
    end
  end

  private

  def analyze!
    if start_of_block?
      @should_add_counter = true
      # @counter = @counter + 1
    elsif end_of_block?
      @counter = @counter - 1
    end

    unless end_of_line?
      @line << @current_character
    end

    unless end_of_word?
      @word << @current_character 
    end
  end

  def obsolete!
      @line = ""
    

    # if end_of_word?
    #   @word = ""
    # end

  
  end

  def end_of_block?
    @current_character == @cfg.block_end
  end

  def start_of_block?
    @current_character == @cfg.block_start
  end

  def word_break_array
    [@cfg.block_start, @cfg.block_end, @cfg.new_line_symbol, " "]
  end

  def end_of_word?
    word_break_array.include? @current_character
  end

  def end_of_line?
    @current_character == @cfg.new_line_symbol
  end
end


reader = Reader.new('./code_samples/oneliner.code')
config = Cfg.new("  ", "{", "}", ";")
sputnik = Sputnik.new(config)

formatter = Formatter.new(reader, sputnik)

formatter.proceed do |chr|
  sputnik.addc(chr) do |s|
    Pogrom.puts(s.expectation)
  end

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