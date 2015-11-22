-- c lib / bindings for libuv
local uv = require 'luv'

-- handle
local handle = require 'async.handle'
-- url parser
local tcp = require 'async.tcp'

-- TCP server/client:
local udp = {}

-- protocols:
udp.protocols = {
   http = 80,
   https = 443,
}

-- url parser:
udp.parseUrl = function(url, cb)
   tcp.parseUrl(url, cb)
end

function udp.listen(domain, cb)
   local server = uv.new_udp()
   local h = handle(server)
   h.settype("udp")
   udp.parseUrl(domain, function(domain)
      local host = domain.host
      local port = domain.port
      uv.udp_bind(server, host, port)
      h.sockname = uv.udp_getsockname(server)
      uv.udp_recv_start(server)
      cb(h)
   end)
   return h
end

function udp.connect(domain, cb)
   local client = uv.new_udp()
   local h = handle(client)
   h.settype("udp")
   udp.parseUrl(domain, function(domain)
      local host = domain.host
      local port = domain.port
      uv.udp_bind(client, host, port)
      h.sockname = uv.udp_getsockname(client)
      cb(h)
   end)
   return h
end

-- UDP lib
return udp
