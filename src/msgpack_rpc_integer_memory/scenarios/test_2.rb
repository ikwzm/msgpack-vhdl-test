require './mksnr.rb'

File.open('test_2.snr','w') do |file|

  i = Requester.new
  o = Responder.new

  VAR_NAME    = 'data'
  MEMORY_SIZE = 4096
  memory      = Array.new(MEMORY_SIZE).map{rand(0xFFFFFFFF)-0x80000000}

  def store(file, i, o, addr, data)
    file.puts i.request( 0x41, "$SET" , [{VAR_NAME => {addr => data}}])
    file.puts o.response(0x41, nil, nil)
  end
  
  def query(file, i, o, addr, data)
    file.puts i.request( 0x41, "$GET" , [{VAR_NAME => {addr => data.size}}])
    file.puts o.response(0x41, nil,     [{VAR_NAME => {addr => data}}])
  end
  
  def check(file, i, o, data)
    file.puts i.request( 0x41, "$GET" , [{VAR_NAME => {0 => nil }}])
    file.puts o.response(0x41, nil,     [{VAR_NAME => {0 => data}}])
  end
  
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2 Start."

  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1 Start."
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1.1 Clear."
  store(file, i, o, 0, memory)
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1.2 Check."
  query(file, i, o, 0, memory)
  file.puts "---"
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.1 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2 Start."
  file.puts "---"
  num = 1
  size_sel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
  20.times do 
    size_sel << rand(MEMORY_SIZE-16)+16
  end
  1000.times do
    addr = rand(MEMORY_SIZE-1)
    size = size_sel[rand(size_sel.size)]
    if addr+size > MEMORY_SIZE then
      size = MEMORY_SIZE-addr
    end
    mode = (rand(9) > 5) ? :STORE : :QUERY
    addr_hex = sprintf("0x%04X",addr)
    file.puts "- MARCHAL  : "
    file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2.#{num} #{mode} ADDR=#{addr_hex} SIZE=#{size}"
    if mode == :STORE then
      data = Array.new(size).map{rand(0xFFFFFFFF)-0x80000000}
      memory[addr,size] = data
      store(file, i, o, addr, memory.slice(addr, size))
    end
    if mode == :QUERY then
      query(file, i, o, addr, memory.slice(addr, size))
    end
    file.puts "---"
    num = num+1
  end
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2 Check."
  file.puts "---"
  check(file, i, o, memory)
  
  file.puts "- MARCHAL  : "
  file.puts "  - SAY    : MsgPack_RPC_Server TEST 2.2 Done."
  file.puts "---"

  file.puts "- MARCHAL  : "
  file.puts "- SAY    : MsgPack_RPC_Server TEST 2 Done."
  file.puts "---"
end
