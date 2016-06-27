require_relative './mksnr.rb'

File.open('test_1.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  FIFO_SIZE = 4096
  memory  = Hash.new
  memory['bin1'] = Array.new
  memory['bin4'] = Array.new
  memory['str4'] = Array.new
  store_name = Hash({'bin1' => 'bin1_i', 'bin4' => 'bin4_i', 'str4' => 'str4'})
  query_name = Hash({'bin1' => 'bin1_o', 'bin4' => 'bin4_o', 'str4' => 'str4'})
  
  def store(file, i, o, name, data)
    if name.match(/^str/) then
      bin = data.pack("C*").to_sym
    else
      bin = data.pack("C*")
    end
    file.puts i.request( 0x41, "$SET" , [{name => bin}])
    file.puts o.response(0x41, nil, nil)
  end
  
  def query(file, i, o, name, data)
    if name.match(/^str/) then
      bin = data.pack("C*").to_sym
    else
      bin = data.pack("C*")
    end
    file.puts i.request( 0x41, "$GET" , [{name => data.size}])
    file.puts o.response(0x41, nil,     [{name => bin}])
  end
  
  def check(file, i, o, name, data)
    if name.match(/^str/) then
      bin = data.pack("C*").to_sym
    else
      bin = data.pack("C*")
    end
    file.puts i.request( 0x41, "$GET" , [{name => nil}])
    file.puts o.response(0x41, nil,     [{name => bin}])
  end

  def generate_random_data(name, size)
    if name.match(/^str/) then
      Array.new(size).map{rand(0x5F)+0x20}
    else
      Array.new(size).map{rand(0xFF)}
    end
  end
  
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1 Start."

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Start."
  file.puts "---"
  ['bin1', 'bin4', 'str4'].each_with_index do | name , n |
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1.#{n+1} #{name} Clear."
    data = generate_random_data(name, FIFO_SIZE)
    memory[name].concat(data)
    store(file, i, o, store_name[name], data)
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1.#{n+1} #{name} Check."
    data = memory[name].shift(FIFO_SIZE)
    query(file, i, o, query_name[name], data)
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Start."
  file.puts "---"
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(FIFO_SIZE-16)+16
  end
  1000.times do |num|
    name = memory.to_a[rand(memory.size)][0]
    size = size_sel[rand(size_sel.size)]
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2.#{num+1}.1 #{name} STORE SIZE=#{size}"
    data = generate_random_data(name, size)
    memory[name].concat(data)
    store(file, i, o, store_name[name], data)
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2.#{num+1}.2 #{name} QUERY SIZE=#{size}"
    data = memory[name].shift(size)
    query(file, i, o, query_name[name], data)
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Start."
  file.puts "---"
  num = 1
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(FIFO_SIZE-16)+16
  end
  100.times do |num|
    name = 'bin4'
    size = size_sel[rand(size_sel.size)]
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3.#{num+1}.1 #{name} STORE SIZE=#{size}"
    data = generate_random_data(name, size)
    memory[name].concat(data)
    store(file, i, o, store_name[name], data)
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3.#{num+1}.2 #{name} QUERY SIZE=#{size}"
    data = memory[name].shift(size)
    check(file, i, o, query_name[name], data)
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.3 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
