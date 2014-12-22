
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattlePlayActivity  = require 'activity.BattlePlayActivity'
local BattleUIActivity    = require 'activity.BattleUIActivity'

local game_ui             = require 'engine.UI' ()
local activities          = {}
local messages            = {}

local function tick ()
  if #activities == 0 then
    return love.event.push 'quit'
  end
  local finished = {}
  for i,activity in ipairs(activities) do
    for _,msg in ipairs(messages) do
      local receive = activity['on'..msg.id]
      if receive then
        receive(activity, msg.args())
      end
    end
    activity:updateTasks()
    messages = activity:pollResults()
    if activity:isFinished() then
      table.insert(finished, i)
    end
  end
  for k=#finished,1,-1 do
    table.remove(activities, finished[k])
  end
end

local function pushMsg (id, ...)
  local info = { n = select('#',...), ... }
  table.insert(
    messages,
    { id = id, args = function () return unpack(info,1,info.n) end }
  )
end

function love.load ()
  table.insert(activities, BattlePlayActivity())
  table.insert(activities, BattleUIActivity(game_ui))
  pushMsg 'Load'
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
      messages = {}
    end
  end
end

function love.keypressed (key)
  pushMsg('KeyPressed', key)
end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
