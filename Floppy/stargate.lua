local component = require("component")
local term = require("term")
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

local incommingGlyphs = ""
function eventHandlers.sgIncommung(glyph)
  
  if ((incommingGlyphs.length % 9) == 0)
    term.setCursor(0, 0)
    incommingGlyphs = glyph
  else
    incommingGlyphs = incommingGlyphs .. glyph
  end
  print(incommingGlyphs)
end

function eventHandlers.sgOutgoing(address)
  print(address)
end

function handleEvent(eventID, ...)
  if (eventID) then
    eventHandlers[eventID](...)
  end
end

event.listen("sgIncomming", handleEvent)
event.listen("sgOutgoing", handleEvent)
