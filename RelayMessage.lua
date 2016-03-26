local component = require("component")
local event = require("event")
local tunnel = component.tunnel
local modem = component.modem

while true do
  local _, _, port, _, ... = event.pull("modem_message")
  modem.broadcast(port, ...)
end
