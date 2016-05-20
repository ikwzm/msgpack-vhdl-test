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
  file.puts i.request( 0x11, "LOOP" , [1,2,3,4])
  file.puts o.response(0x11, nil, [1,2,3,4])
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Start."
  file.puts "---"
  file.puts i.request( 0x21, "ADD" , [16,17])
  file.puts o.response(0x21, nil, 33)
  file.puts "---"
  file.puts i.request( 0x22, "ADD" , [-1,17])
  file.puts o.response(0x22, nil, 16)
  file.puts "---"
  file.puts i.request( 0x23, "ADD" , [500,300])
  file.puts o.response(0x23, nil, 800)
  file.puts "---"
  file.puts i.request( 0x23, "ADD" , [100000,-100001])
  file.puts o.response(0x23, nil, -1)
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Start."
  file.puts "---"
  file.puts i.request( 0x31, "START" , [])
  file.puts o.response(0x31, nil, nil)
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.4 Start."
  file.puts "---"
  param_c_addr = 0x00000000
  param_c_data = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  file.puts i.request( 0x41, "$SET" , [{'PARAM_A' => 100, 'PARAM_B' => 100, 'PARAM_C' => {param_c_addr => param_c_data}}])
  file.puts o.response(0x41, nil, nil)
  file.puts "---"
  file.puts i.request( 0x41, "$GET" , [{'PARAM_A' => nil, 'PARAM_B' => nil, 'PARAM_C' => {param_c_addr => param_c_data.size}}])
  file.puts o.response(0x41, nil,     [{'PARAM_A' => 100, 'PARAM_B' => 100, 'PARAM_C' => {param_c_addr => param_c_data}}])
  file.puts "---"
  file.puts i.request( 0x41, "$SET" , [{'PARAM_A' => 100000, 'PARAM_B' => 100000}])
  file.puts o.response(0x41, nil, nil)
  file.puts "---"
  file.puts i.request( 0x41, "$GET" , [{'PARAM_A' => nil   , 'PARAM_B' => nil   }])
  file.puts o.response(0x41, nil,     [{'PARAM_A' => 100000, 'PARAM_B' => 100000}])
  file.puts "---"
  file.puts i.request( 0x41, "$SET" , [{'PARAM_A' => -8, 'PARAM_B' => -100000}])
  file.puts o.response(0x41, nil, nil)
  file.puts "---"
  file.puts i.request( 0x41, "$GET" , [{'PARAM_A' => nil, 'PARAM_B' => nil    }])
  file.puts o.response(0x41, nil,     [{'PARAM_A' => -8 , 'PARAM_B' => -100000}])
  file.puts "---"
  file.puts i.request( 0x41, "$SET" , [{'PARAM_A' => -8,  'PARAM_B' => -8000000000}])
  file.puts o.response(0x41, nil, nil)
  file.puts "---"
  file.puts i.request( 0x41, "$GET" , [{'PARAM_A' => nil, 'PARAM_B' => nil}])
  file.puts o.response(0x41, nil,     [{'PARAM_A' => -8 , 'PARAM_B' => -8000000000}])
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
