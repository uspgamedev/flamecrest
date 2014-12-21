
local FRAME = 1/60

local vec2                = require 'lux.geom.Vector'
local BattlePlayActivity      = require 'activity.BattlePlayActivity'
local BattleScreenElement = require 'ui.BattleScreenElement'

local game_ui             = require 'engine.UI' ()
local activities          = {}
local messages            = {}

local function tick ()
  for _,activity in ipairs(activities) do
    for _,msg in ipairs(messages) do
      local receive = activity['on'..msg.id]
      if receive then
        receive(activity, msg.args())
      end
    end
    activity:updateTasks()
    messages = activity:pollResults()
  end
end

function love.load ()
  table.insert(activities, BattlePlayActivity(game_ui))
  table.insert(messages, { id = 'Load', args = function () end })
  game_ui:add(BattleScreenElement())
  tick()
  game_ui:receiveResults(messages)
end

do

  local lag = 0

  function love.update (dt)
    lag = lag + dt
    while lag >= FRAME do
      messages = {}
      tick()
      game_ui:receiveResults(messages)
      game_ui:refresh()
      lag = lag - FRAME
    end
  end

end

function love.draw ()
  game_ui:draw(love.graphics, love.window)
end
