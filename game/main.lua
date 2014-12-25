
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattleStartActivity = require 'activity.BattleStartActivity'
local Event               = require 'engine.Event'
local Queue               = require 'engine.Queue'

local game_ui             = require 'engine.UI' ()
local activities          = {}

local function addActivity (activity)
  table.insert(activities, activity)
  activity:receiveEvent(Event("Load"))
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
      table.insert(activities, finished[k], scheduled[i])
    end
  end
end

function love.load ()
  addActivity(BattleStartActivity(game_ui))
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
  broadcastEvent(Event('KeyPressed', key))
end

function love.mousepressed (x, y, button)
  game_ui:mouseAction('Pressed', vec2:new{x,y}, button)
end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
