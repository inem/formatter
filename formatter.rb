#!/usr/bin/ruby
 
input = $stdin.read

counter = 0
space_sympol = "  "
line = ""

end_of_line = false
should_add_counter = false
previous_character = nil

input.split("").each do |character|
  if end_of_line
    puts "#{space_sympol*counter}#{line}#{previous_character}"
    counter = counter + 1 if should_add_counter
    should_add_counter = false
    line = ""
  end

  end_of_line = false
  

  if character == "{"
    should_add_counter = true
    # counter = counter + 1
  elsif character == "}"
    counter = counter - 1
  elsif character == ";"
    end_of_line = true
  end

  unless end_of_line
    line << character
  end 
  
  # puts output
  previous_character = character
end
puts line