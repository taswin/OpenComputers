local component = require("component")
term = require("term")

local reactor
if component.isAvailable("br_reactor") then
  reactor = component.br_reactor
end

local modem
if component.isAvailable("modem") then
  modem = component.modem
end

local tunnel
if component.isAvailable("tunnel") then
  tunnel = component.tunnel
end

local args = {...}
local port = tostring(args[1])

if port then
  if modem or tunnel then
    if reactor then
      os.execute("BRC.lua " .. port)
    elseif term then
      os.execute("Display.lua " .. port)
    else
      print("No reactor or terminal found!")
    end
  else
    print("No network or link cards found!")
  end
else
  print("No port given!")
end
