--require('mobdebug').start()

local async = require 'async'

local count = 0

local server = async.udp.listen({host='0.0.0.0', port=8483}, function(client)
   print(string.format("new connection at %s: %s: %s", os.date("%c"), tostring(client), client))
   client.ondatagram(function(data, domain, flags)
      --print(string.format("received (%s): %s",data:len(), data))
      count = count + 1
      print(string.format("%d: received (%s byte), ip=%s:%d, flags = %d", count, data:len(), domain.address, domain.port, flags))
      --client.write(data)
   end)
   client.onend(function()
      print('client ended')
   end)
   client.onclose(function()
      print('closed.')
      collectgarbage()
      print(collectgarbage("count") * 1024)
   end)
end)

local closetimer = async.setTimeout(10000, function()
   server.stopdatagram()
   print(string.format("datagram is stopped at %s: %s", os.date("%c"), tostring(server)))
end)

async.repl()

async.go()

--require('mobdebug').stop()