f = File.open('./code_samples/oneliner.code','r')
while 1 do
  character_code = f.getc
  if character_code
    puts character_code.chr 
  else
    exit
  end
end
