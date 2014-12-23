
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattlePlayActivity  = require 'activity.BattlePlayActivity'
local BattleUIActivity    = require 'activity.BattleUIActivity'
local Event               = require 'engine.Event'
local Queue               = require 'engine.Queue'

local game_ui             = require 'engine.UI' ()
local activities          = {}

local function addActivity (activity)
  table.insert(activities, activity)
end

local function removeActivity (index)
  local activity = activities[index]
  table.remove(activities, index)
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
    removeActivity(finished[k])
  end
end

function love.load ()
  addActivity(BattlePlayActivity())
  addActivity(BattleUIActivity(game_ui))
  broadcastEvent(Event 'Load')
  tick()
end

do
  local lag = 0
  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
      tick()
      game_ui:refresh()
      lag = lag - FRAME
    end
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
