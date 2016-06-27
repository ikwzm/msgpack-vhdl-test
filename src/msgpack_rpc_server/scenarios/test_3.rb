require './mksnr.rb'

File.open('test_3.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3 Start."
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.1 Start."
  file.puts "---"
  [0x01,0x08,0x25,0x3C].each do |addr|
    [0,1,8,400,1681,2854].each do |size|
      data = Array.new(size).map{rand(0xFFFFFFFF)-0x80000000}
      file.puts "---"
      file.puts "- MARCHAL  : "
      file.puts "  - SAY    : STORE " + sprintf("ADDR=0x%08X", addr) + " SIZE=#{size}"
    # file.puts "  - SAY    : DATA=#{data}"
      file.puts i.request( 0x41, "$SET" , [{'PARAM_C' => {addr => data}}])
      file.puts o.response(0x41, nil, nil)
      file.puts "---"
      file.puts "- MARCHAL  : "
      file.puts "  - SAY    : QUERY " + sprintf("ADDR=0x%08X", addr) + " SIZE=#{size}"
      file.puts i.request( 0x41, "$GET" , [{'PARAM_C' => {addr => data.size}}])
      file.puts o.response(0x41, nil,     [{'PARAM_C' => {addr => data}}])
    end 
  end
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 3 Done."
  file.puts "---"
end
