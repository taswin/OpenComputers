local event = require "event"

local char_t = string.byte("t")
local running = true

function unknownEvent()
  --Nothing
end

local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_t) then
    running = false
  end
end

function myEventHandlers.modem_message(reciver, sender, rPort, distance, message)
  display(message)
end

function handleEvent(eventID, ...)
  if (eventID) then
    myEventHandlers[eventID](...)
  end
end

event.listen("key_up", handleEvent)
event.listen("modem_message", handleEvent)
