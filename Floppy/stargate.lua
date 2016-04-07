local component = require("component")
local sg = component.stargate

function dial(address)
  return sg.connect(address)
end

function terminate()
  sg.disconnect()
end

function getLocalState()
  if(sg.isActive()) then
    if(sg.isDialing()) then
      return "dialing"
   else
     return "connected"
    end
  else
    return "disconnected"
  end
end

function getLocalFuelFound()
  return sg.hasFuel()
end

function getLocalAddress()
  return sg.getAddress()
end

function gerRemoteState(address)
  if (sg.isBusy(address))
    return "busy"
  else
    return "available"
  end
end

function unknownEvent()
end

local eventHandlers = setmetatable({}, { __index = function() return unknownEvent end })

function eventHandlers.sgIncommung(glyph)
  --
end

function eventHandlers.sgOutgoing(address)
  --
end

function handleEvent(eventID, ...)
  if (eventID) then
    eventHandlers[eventID](...)
  end
end

event.listen("sgIncomming", handleEvent)
event.listen("sgOutgoing", handleEvent)
