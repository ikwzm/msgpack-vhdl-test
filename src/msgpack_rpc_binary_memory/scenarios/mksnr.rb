require 'msgpack'

class ScenarioWriter
  
  def xfer_to_str(msg, last)
    msg_list = msg.map{|ch| sprintf("0x%02X",ch)}
    msg_line = Array.new
    while(msg_list.size > 0) do
      msg_line.push(msg_list.slice!(0..15).join(","))
    end
    msg_str  = msg_line.join("]}\n  - XFER   : {DATA: [")
    if (last) then
      return "  - XFER   : {DATA: [#{msg_str}], LAST:1}\n"
    else
      return "  - XFER   : {DATA: [#{msg_str}]}\n"
    end
  end 
end

class Requester < ScenarioWriter

  def request(msgid, method, params)
    "- I  :\n" << xfer_to_str([0, msgid, method, params].to_msgpack.each_byte, FALSE)
  end

end
class Responder < ScenarioWriter

  def response(msgid, error, result)
    "- O  :\n" << xfer_to_str([1, msgid, error , result].to_msgpack.each_byte, TRUE )
  end

end

