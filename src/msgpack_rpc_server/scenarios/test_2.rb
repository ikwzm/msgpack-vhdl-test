require './mksnr.rb'

File.open('test_2.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  file.puts "---"
  file.puts i.request( 0x10, "LOOPLOOPLOOPLOOPLOOP" , [1,2,3,4])
  file.puts o.response(0x10, "NoMethodError", "LOOPLOOPLOOPLOOPLOOP")
  file.puts "---"

end
