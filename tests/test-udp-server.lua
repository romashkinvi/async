--require('mobdebug').start()

local async = require 'async'

local server = async.udp.listen({host='0.0.0.0', port=8483}, function(client)
   print('new connection ', tostring(client), ' :',client)
   client.ondata(function(data)
      --print(string.format("received (%s): %s",data:len(), data))
      print(client)
      print(string.format("received (%s)",data:len()))
      --client.write(data)
   end)
--   client.onend(function()
--      print('client ended')
--   end)
--   client.onclose(function()
--      print('closed.')
--      collectgarbage()
--      print(collectgarbage("count") * 1024)
--   end)
end)

async.repl()

async.go()

--require('mobdebug').stop()