require './mksnr.rb'

File.open('test_1.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1 Start."
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Start."
  file.puts "---"
  [0x01,0x08,0x25,0x3C].each do |addr|
    [0,1,8,400,1681,2854].each do |size|
      data = Array.new(size).map{rand(0xFFFFFFFF)-0x80000000}
      file.puts "---"
      file.puts "- MARCHAL  : "
      file.puts "  - SAY    : STORE " + sprintf("ADDR=0x%08X", addr) + " SIZE=#{size}"
    # file.puts "  - SAY    : DATA=#{data}"
      file.puts i.request( 0x41, "$SET" , [{'data' => {addr => data}}])
      file.puts o.response(0x41, nil, nil)
      file.puts "---"
      file.puts "- MARCHAL  : "
      file.puts "  - SAY    : QUERY " + sprintf("ADDR=0x%08X", addr) + " SIZE=#{size}"
      file.puts i.request( 0x41, "$GET" , [{'data' => {addr => data.size}}])
      file.puts o.response(0x41, nil,     [{'data' => {addr => data}}])
    end 
  end
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
