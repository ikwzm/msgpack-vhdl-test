require './mksnr.rb'

File.open('test_1.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  MEMORY_SIZE = 4096
  memory  = Hash.new
  ['bin1', 'bin2', 'bin4'].each do | m |
    memory[m] = Array.new(MEMORY_SIZE).map{rand(0xFF)}
  end
  ['str4'].each do | m |
    memory[m] = Array.new(MEMORY_SIZE).map{rand(0x5F)+0x20}
  end

  def store(file, i, o, name, addr, data)
    if name.match(/^str/) then
      bin = data.pack("C*").to_sym
    else
      bin = data.pack("C*")
    end
    file.puts i.request( 0x41, "$SET" , [{name => {addr => bin}}])
    file.puts o.response(0x41, nil, nil)
  end
  
  def query(file, i, o, name, addr, data)
    if name.match(/^str/) then
      bin = data.pack("C*").to_sym
    else
      bin = data.pack("C*")
    end
    file.puts i.request( 0x41, "$GET" , [{name => {addr => data.size}}])
    file.puts o.response(0x41, nil,     [{name => {addr => bin}}])
  end
  
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1 Start."

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Start."
  file.puts "---"
  ['bin1', 'bin2', 'bin4', 'str4'].each_with_index do | name , n |
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1.#{n+1} #{name} Clear."
    store(file, i, o, name, 0, memory[name])
    file.puts "---"
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1.#{n+1} #{name} Check."
    query(file, i, o, name, 0, memory[name])
    file.puts "---"
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Start."
  file.puts "---"
  num = 1
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(MEMORY_SIZE-16)+16
  end
  1000.times do
    name = memory.to_a[rand(memory.size)][0]
    addr = rand(MEMORY_SIZE-1)
    size = size_sel[rand(size_sel.size)]
    if addr+size > MEMORY_SIZE then
      size = MEMORY_SIZE-addr
    end
    mode = (rand(9) > 5) ? :STORE : :QUERY
    addr_hex = sprintf("0x%04X",addr)
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2.#{num} #{name} #{mode} ADDR=#{addr_hex} SIZE=#{size}"
    if mode == :STORE then
      if name.match(/^str/) then
        data = Array.new(size).map{rand(0x5F)+0x20}
      else
        data = Array.new(size).map{rand(0xFF)}
      end
      memory[name][addr,size] = data
      store(file, i, o, name, addr, memory[name].slice(addr, size))
    end
    if mode == :QUERY then
      query(file, i, o, name, addr, memory[name].slice(addr, size))
    end
    file.puts "---"
    num = num+1
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Check."
  file.puts "---"
  ['bin1', 'bin2', 'bin4', 'str4'].each_with_index do | name , n |
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2.#{num+n} #{name} Check."
    query(file, i, o, name, 0, memory[name])
    file.puts "---"
  end
  
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 1.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 1 Done."
  file.puts "---"
end
