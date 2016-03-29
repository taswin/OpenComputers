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

if component.isAvailable("term") then
  local term = component.term
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
