require './mksnr.rb'

File.open('test_3.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  MEMORY_SIZE = 4096
  memory  = Hash.new
  memory['memory1'] = Array.new
  memory['memory4'] = Array.new
  store_name = Hash({'memory1' => 'memory1', 'memory4' => 'memory4'})
  query_name = Hash({'memory1' => 'memory1', 'memory4' => 'memory4'})
  
  def store(file, i, o, name, addr, data)
    file.puts i.request( 0x41, "$SET" , [{name => {addr => data}}])
    file.puts o.response(0x41, nil, nil)
  end
  
  def query(file, i, o, name, addr, data)
    file.puts i.request( 0x41, "$GET" , [{name => {addr => data.size}}])
    file.puts o.response(0x41, nil,     [{name => {addr => data}}])
  end
  
  def check(file, i, o, name, data)
    file.puts i.request( 0x41, "$GET" , [{name => {0 => nil }}])
    file.puts o.response(0x41, nil,     [{name => {0 => data}}])
  end

  def generate_random_data(name, size)
    Array.new(size).map{rand(2)>=1}
  end
  
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3 Start."

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.1 Start."
  file.puts "---"
  ['memory1','memory4'].each_with_index do | name , n |
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.1.#{n+1} #{name} Clear."
    data = generate_random_data(name, MEMORY_SIZE)
    memory[name].concat(data)
    store(file, i, o, store_name[name], 0, memory[name])
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.1.#{n+1} #{name} Check."
    check(file, i, o, query_name[name],    memory[name])
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.2 Start."
  file.puts "---"
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(MEMORY_SIZE-16)+16
  end
  100.times do |num|
    name = memory.to_a[rand(memory.size)][0]
    addr = rand(MEMORY_SIZE-1)
    size = size_sel[rand(size_sel.size)]
    if addr+size > MEMORY_SIZE then
      size = MEMORY_SIZE-addr
    end
    mode = (rand(9) > 5) ? :STORE : :QUERY
    addr_hex = sprintf("0x%04X",addr)
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.2.#{num+1} #{mode} #{name} ADDR=#{addr_hex} SIZE=#{size}"
    if mode == :STORE then
      data = generate_random_data(name, size)
      memory[name][addr,size] = data
      store(file, i, o, store_name[name], addr, memory[name].slice(addr, size))
    end
    if mode == :QUERY then
      query(file, i, o, query_name[name], addr, memory[name].slice(addr, size))
    end
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 3.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 3 Done."
  file.puts "---"
end
