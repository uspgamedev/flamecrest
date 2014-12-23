
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattlePlayActivity  = require 'activity.BattlePlayActivity'
local BattleUIActivity    = require 'activity.BattleUIActivity'
local Event               = require 'engine.Event'
local Queue               = require 'engine.Queue'

local game_ui             = require 'engine.UI' ()
local activities          = {}
local events              = {}

local function addActivity (activity)
  table.insert(activities, activity)
  events[activity] = Queue(32)
end

local function removeActivity (index)
  local activity = activities[index]
  table.remove(activities, index)
  events[activity] = nil
end

local function pushEvent (ev)
  for _,activity in ipairs(activities) do
    events[activity]:push(ev)
  end
end

local function tick ()
  if #activities == 0 then
    return love.event.push 'quit'
  end
  local finished = {}
  for i,activity in ipairs(activities) do
    local queue = events[activity]
    while not queue:isEmpty() do
      local ev = queue:pop()
      local receive = activity['on'..ev:getID()]
      if receive then
        receive(activity, ev.getArgs())
      end
    end
    activity:updateTasks()
    for _,ev in ipairs(activity:pollEvents()) do
      pushEvent(ev)
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
  pushEvent(Event 'Load')
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
  pushEvent(Event('KeyPressed', key))
end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
