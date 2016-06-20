require './mksnr.rb'

File.open('test_1.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1 Start."
  file.puts "---"

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Start."
  file.puts i.request( 0x41, "$SET" , [{'status' => true }])
  file.puts o.response(0x41, nil    , nil)

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Start."
  file.puts i.request( 0x41, "$GET" , [{'status' => nil  }])
  file.puts o.response(0x41, nil    , [{'status' => true }])

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Start."
  file.puts i.request( 0x41, "$SET" , [{'status' => false}])
  file.puts o.response(0x41, nil    , nil)

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.4 Start."
  file.puts i.request( 0x41, "$GET" , [{'status' => nil  }])
  file.puts o.response(0x41, nil    , [{'status' => false}])

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.5 Start."
  file.puts i.request( 0x41, "control", [true])
  file.puts o.response(0x41, nil      , true  )

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.6 Start."
  file.puts i.request( 0x41, "control", [false])
  file.puts o.response(0x41, nil      , false  )

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
