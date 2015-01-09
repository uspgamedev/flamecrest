
local FRAME = 1/60

local class       = require 'lux.oo.class'
local vec2        = require 'lux.geom.Vector'

local engine      = class.package 'engine'
local battle      = class.package 'activity.battle'

local game_ui
local activities  = {}

function addActivity (activity, i)
  i = i or #activities+1
  table.insert(activities, i, activity)
  activity:receiveEvent(engine.Event("Load"))
end

local function removeActivity (index)
  local activity = activities[index]
  table.remove(activities, index)
  return activity
end

function broadcastEvent (ev)
  for _,activity in ipairs(activities) do
    activity:receiveEvent(ev)
  end
end

local function tick ()
  if #activities == 0 then
    return love.event.push 'quit'
  end
  local finished = {}
  for i,activity in ipairs(activities) do
    activity:processEvents()
    activity:updateTasks()
    for ev in activity:pollEvents() do
      broadcastEvent(ev)
    end
    if activity:isFinished() then
      table.insert(finished, i)
    end
  end
  for k=#finished,1,-1 do
    local removed = removeActivity(finished[k])
    local scheduled = removed:getScheduled()
    for i = #scheduled,1,-1 do
      addActivity(scheduled[i], finished[k])
    end
  end
end

function love.load ()
  game_ui = engine.UI()
  addActivity(battle.StartActivity(game_ui))
  tick()
end

do
  local lag = 0
  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
      tick()
      lag = lag - FRAME
    end
    game_ui:refresh()
  end
end

function love.keypressed (key)
  broadcastEvent(engine.Event('KeyPressed', key))
end

function love.mousepressed (x, y, button)
  game_ui:mouseAction('Pressed', vec2:new{x,y}, button)
end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
