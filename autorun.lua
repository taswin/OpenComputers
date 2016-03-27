local component = require("component")
if component.isAvailable("br_reactor") then
  local reactor = component.br_reactor
end

if component.isAvailable("modem") then
local modem = component.modem
end

if component.isAvailable("tunnel") then
local tunnel = component.tunnel
end

local args = {...}
local port = tostring(args[1])

if recator then
  if modem then
  os.execute("BRC.lua " .. port)
  else if tunnel then
  os.execute("BRC.lua " .. port)
  end
else if modem then
  os.execute("Display.lua " .. port)
else if tunnel then
  os.execute("Display.lua " .. port)
end
