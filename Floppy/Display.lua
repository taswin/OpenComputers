local event = require "event"
local component = require("component")
term = require("term")
local modem = component.modem
local tunnel = component.tunnel

local args = {...}
local port = args[1]
modem.open(port)

function unknownEvent()
  --Nothing
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == string.byte("t")) then
    running = false
  end
end

function myEventHandlers.modem_message(reciver, sender, rPort, distance, msg)
  local display = serialization.unserialize(msg)
  
  for x = 1, #display do
    term.setCursor(1, i)
    term.write(display[i])
  end
end

function handleEvent(eventID, ...)
  if (eventID) then
    myEventHandlers[eventID](...)
  end
end

event.listen("key_up", handleEvent)
event.listen("modem_message", handleEvent)
