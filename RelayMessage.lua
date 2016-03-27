local component=require"component"
local event=require"event"

local link=component.tunnel
local modem=component.modem
local port=100

local function forward(event, rec_addr, from, port, distance, message)
  modem.broadcast(port, message)
end

event.listen("modem_message",forward)
