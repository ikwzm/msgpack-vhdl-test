require 'msgpack'

class Requester

  def request(msgid, method, params)
    msg  = [0, msgid, method, params].to_msgpack.each_byte.map{|ch| sprintf("0x%02X",ch)}.join(',')
    snr  = "- I  :\n" << "  - XFER   : {DATA: [#{msg}]}\n"
  end

end
class Responder

  def response(msgid, error, result)
    msg = [1, msgid, error, result].to_msgpack.each_byte.map{|ch| sprintf("0x%02X",ch)}.join(',')
    snr = "- O  :\n" << "  - XFER   : {DATA: [#{msg}], LAST:1}\n"
  end

end

