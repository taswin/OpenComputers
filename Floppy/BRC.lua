local component = require("component")
local event = require("event")
local serialization = require("serialization")
local reactor = component.br_reactor
local modem = component.modem
local tunnel = component.tunnel

local running = true

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

function handleEvent(eventID, ...)
  if (eventID) then
    myEventHandlers[eventID](...)
  end
end

function transmit(msg)
  if modem then
    modem.broadcast(port, msg)
  end
  
  if tunnel then
    tunnel.send(msg)
  end
end

function reactorStats()
  local active = reactor.getActive()
  
  local rf_tick = reactor.getEnergyProducedLastTick()
  
  local power = reactor.getEnergyStored()
  local maxPoower = 10000000
  local powerPercent = math.floor(power / maxPower * 100)
  
  local fuel = reactor.getFuelAmount()
  local maxFuel = reactor.getFuelAmountMax()
  local fuelPercent = math.floor(fuel / maxFuel * 100)
  
  local msg = {"", "", ""}
  
  if active then
    msg[1] = "The reactor is currently ON and producing " .. tostring(rf_tick) .. "RF/tick")
  else
    msg[1] = "The reactor is currently OFF")
  end

  msg[2] = "The current ammount of power stored in the reactor is " .. tostring(power) .. "/" + tostring(maxPower) .. " RF or " .. tostring(powerPercent) .. "%"
  
  msg[3] = "The current ammount of fuel stored in the reactor is " .. tostring(fuelPercent) .. "%"
  
  transmit(serialization.serialize(msg))
  return powerPercent
end

event.listen("key_up", handleEvent)

while running do  
  if reactor then
    percent = getReactorStats()
    reactor.setAllControlRodLevels(percent)
  end
end
