local component = require("component")
local term = require("term")
local event = require("event")
local keyboard = require("keyboard")
local reactor = component.br_reactor
--local gpu = component.gpu
local modem = component.modem
local tunnel = component.tunnel

local args = {...}
if args[1] then
  local port = args[1]
else
  local port = 0000
end

function transmit(...)
  if modem then
    modem.broadcast(port, ...)
  end
  
  if tunnel then
    tunnel.send(...)
  end
end

function getReactorStats()
  local active = reactor.getActive()
  
  local rf_tick = reactor.getEnergyProducedLastTick()
  
  local power = reactor.getEnergyStored()
  local maxPoower = maxPower
  local powerPercent = math.floor(power / maxPower * 100)
  
  local fuel = reactor.getFuelAmount()
  local maxFuel = reactor.getFuelAmountMax()
  local fuelPercent = math.floor(fuel / maxFuel * 100)
  
  transmit(active, rf_tick, power, maxPower, powerPercent, fuel, maxFuel, fuelPercent)
end

function setTermDisplay()
  term.setCursorBlink(false)
  local active, rf_tick, power, maxPower, powerPercent, fuel, maxFuel, fuelPercent
  
  if modem then
    modem.open(port)
    reciever, sender, rPort, distance, ... = event.pull("modom_message")
    if rPort == port then
      active, rf_tick, power, maxPower, powerPercent, fuel, maxFuel, fuelPercent = ...
    end
  end
  
  term.clear()
  
  term.setCursor(1, 1)
  if active then
    term.write("Current reactor state: " .. "ON")
  else
    term.write("Current reactor state: " .. "OFF")
  end
  
  term.setCursor(1, 2)
  term.write("Currently producing " .. tostring(rf_tick) .. "RF/tick")
  
  term.setCursor(1, 3)
  term.write("Current stored power: " .. tostring(power) .. "/" + tostring(maxPower) .. " RF or " .. tostring(powerPercent) .. "%")
  
  term.setCursor(1, 4)
  term.write("Current stored fuel percent: " .. tostring(fuelPercent) .. "%")
end

function getTerminate()
  if (keyboard.isKeyDown(keyboard.keys.w) and keyboard.isControlDown) then
    return false
  else
    return true
  end
end

local running = true
while running do  
  if reactor then
    getReactorStats()
    reactor.setAllControlRodLevels(powerPercent)
  end
  
  if term then
    setTermDisplay()
  end
  
  if keyboard then
    running = getTerminate()
  end
end
