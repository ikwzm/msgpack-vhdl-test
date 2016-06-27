require_relative './mksnr.rb'

File.open('test_2.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  FIFO_SIZE = 4096
  memory  = Hash.new
  memory['stream1'] = Array.new
  memory['stream4'] = Array.new
  store_name = Hash({'stream1' => 'stream1', 'stream4' => 'stream4'})
  query_name = Hash({'stream1' => 'stream1', 'stream4' => 'stream4'})
  
  def store(file, i, o, name, data)
    file.puts i.request( 0x41, "$SET" , [{name => data}])
    file.puts o.response(0x41, nil, nil)
  end
  
  def query(file, i, o, name, data)
    file.puts i.request( 0x41, "$GET" , [{name => data.size}])
    file.puts o.response(0x41, nil,     [{name => data}])
  end
  
  def check(file, i, o, name, data)
    file.puts i.request( 0x41, "$GET" , [{name => nil }])
    file.puts o.response(0x41, nil,     [{name => data}])
  end

  def generate_random_data(name, size)
    Array.new(size).map{rand(2)>=1}
  end
  
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2 Start."

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1 Start."
  file.puts "---"
  ['stream1','stream4'].each_with_index do | name , n |
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1.#{n+1} #{name} Clear."
    data = generate_random_data(name, FIFO_SIZE)
    memory[name].concat(data)
    store(file, i, o, store_name[name], data)
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1.#{n+1} #{name} Check."
    data = memory[name].shift(FIFO_SIZE)
    query(file, i, o, query_name[name], data)
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2 Start."
  file.puts "---"
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(FIFO_SIZE-16)+16
  end
  100.times do |num|
    name = memory.to_a[rand(memory.size)][0]
    size = size_sel[rand(size_sel.size)]
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2.#{num+1}.1 #{name} STORE SIZE=#{size}"
    data = generate_random_data(name, size)
    memory[name].concat(data)
    store(file, i, o, store_name[name], data)
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2.#{num+1}.2 #{name} QUERY SIZE=#{size}"
    data = memory[name].shift(size)
    query(file, i, o, query_name[name], data)
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 2 Done."
  file.puts "---"
end
