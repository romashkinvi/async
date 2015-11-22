--require('mobdebug').start()

local async = require 'async'

local client = async.udp.connect('tcp://127.0.0.1:8483/', function(client)
   print('new connection:',client)
   client.ondatagram(function(data)
      print('received:',data)
   end)
   client.onend(function()
      print('client ended')
   end)
   client.onclose(function()
      print('closed.')
   end)
   client.write('test', function() end)

   local interval = async.setInterval(200, function()
      --client.write('test_ontimer', function() end)
   end)

   async.setTimeout(1000, function()
      client.close()
      interval.clear()
   end)
end)

async.go()

--require('mobdebug').stop()
