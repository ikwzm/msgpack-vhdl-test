require_relative './mksnr.rb'

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
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m0() "
  file.puts "---"
  file.puts i.request( 0x41, "m0" , [] )
  file.puts o.response(0x41, nil  , nil)
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Start."
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : tvar <= false "
  file.puts "---"
  file.puts i.request( 0x41, "$SET", [{"tvar" => FALSE}])
  file.puts o.response(0x41, nil   , nil)
  file.puts i.request( 0x41, "$GET", [{"tvar" => nil  }])
  file.puts o.response(0x41, nil   , [{"tvar" => FALSE}])
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m1(true ) => false"
  file.puts "---"
  file.puts i.request( 0x41, "m1", [TRUE ])
  file.puts o.response(0x41, nil ,  FALSE )
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m1(false) => false"
  file.puts "---"
  file.puts i.request( 0x41, "m1", [FALSE])
  file.puts o.response(0x41, nil ,  FALSE )
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : tvar <= true "
  file.puts "---"
  file.puts i.request( 0x41, "$SET", [{"tvar" => TRUE }])
  file.puts o.response(0x41, nil   , nil)
  file.puts i.request( 0x41, "$GET", [{"tvar" => nil  }])
  file.puts o.response(0x41, nil   , [{"tvar" => TRUE }])
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m1(true) => true"
  file.puts "---"
  file.puts i.request( 0x41, "m1", [TRUE ])
  file.puts o.response(0x41, nil ,  TRUE  )
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m1(false) => false"
  file.puts "---"
  file.puts i.request( 0x41, "m1", [FALSE])
  file.puts o.response(0x41, nil ,  FALSE )
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Start."
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : STORE bvar = 12, bmem[0..6] = [3,4,5,6,7,8,9] "
  file.puts "---"
  file.puts i.request( 0x41, "$SET", [{"bvar" => 12 , "bmem" => {0 => [3,4,5,6,7,8,9]}}])
  file.puts o.response(0x41, nil   , nil)
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : QUERY bvar = 12, bmem[0..6] = [3,4,5,6,7,8,9] "
  file.puts "---"
  file.puts i.request( 0x41, "$GET", [{"bvar" => nil}, {"bmem" => {0 => 7}}])
  file.puts o.response(0x41, nil   , [{"bvar" => 12 }, {"bmem" => {0 => [3,4,5,6,7,8,9]}}])
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : m2(1, 0) => 16"
  file.puts "---"
  file.puts i.request( 0x41, "m2", [1, 0])
  file.puts o.response(0x41, nil ,  16   )
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
