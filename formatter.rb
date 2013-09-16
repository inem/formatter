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
  attr_accessor :spacer, :start, :finish, :new_line_symbol
  def initialize(spacer, start, finish, new_line_symbol)
    @spacer = spacer
    @start = start
    @finish = finish
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

# class Pogrom
#   def self.puts(str)
#     print str
#   end
# end

class Sputnik
  attr_accessor :word, :line, :cfg, :character, :previous_character
  
  def initialize(config)
    @word = ""
    @line = ""
    @cfg = config
    @character = nil
    @previous_character = nil
    @counter = 0
    @should_add_counter = false
  end

  def addc(chr)
    @character = chr

    analyze!

    if @should_add_counter
      @counter = @counter + 1
      @should_add_counter = false
    end

    yield(self)
    
    word = "" if end_of_word?
    line = "" if end_of_line?
    @previous_character = @character
  end
    
  def expectation
    if end_of_line?
      "\n#{@cfg.spacer*@counter}"
    elsif end_of_block?
      "\n#{@cfg.spacer*(@counter)}"
    else
      ""
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
      @line << @character
    end

    unless end_of_word?
      @word << @character 
    end
  end

  def end_of_block?
    @character == @cfg.finish
  end

  def start_of_block?
    @character == @cfg.start
  end

  def word_break_array
    [@cfg.start, @cfg.finish, @cfg.new_line_symbol, " "]
  end

  def end_of_word?
    word_break_array.include? @character
  end

  def end_of_line?
    @character == @cfg.new_line_symbol
  end
end


reader = Reader.new('./code_samples/oneliner.code')
config = Cfg.new("  ", "{", "}", ";")
sputnik = Sputnik.new(config)

formatter = Formatter.new(reader, sputnik)

formatter.proceed do |chr|
  sputnik.addc(chr) do |s|
    print s.character
    print s.expectation
  end

end