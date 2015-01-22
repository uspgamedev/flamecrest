
local class   = require 'lux.oo.class'
local vec2    = require 'lux.geom.Vector'

local engine  = class.package 'engine'
local battle  = class.package 'activity.battle'
local ui      = class.package 'ui'

function battle:PickTargetActivity (UI, action)

  engine.Activity:inherit(self)

  local combat

  --[[ Event receivers ]]-------------------------------------------------------

  function self.__accept:Load ()
    UI:find("screen"):displayRange(action:getAtkRange())
  end

  function self.__accept:KeyPressed (key)
    if not combat and key == 'escape' then
      self:finish()
    end
  end

  function self.__accept:TileHovered (tile)
    combat = action:startCombat(tile)
    if combat then
      local playerstats = {}
      local foestats = {}
      playerstats.hp, foestats.hp = combat:getHPs()
      playerstats.dmg, foestats.dmg = combat:calculateDmgs()
      playerstats.hit, foestats.hit = combat:calculateHits()
      playerstats.crit, foestats.crit = combat:calculateCrits()

      local playercombatwindow = ui.TextElement( "combatwindow1", "", 14, vec2:new{20,20}, vec2:new{48,144} )
      local foecombatwindow = ui.TextElement( "combatwindow2", "", 14, vec2:new{88,20}, vec2:new{48,144} )
      local playertext, foetext = "", ""
      for k,v in pairs(playerstats) do
        playertext = playertext .. k .. ": " .. playerstats[k] .. "\n"
        foetext = foetext .. k .. ": " .. foestats[k] .. "\n"
      end
      playercombatwindow:setText(playertext)
      foecombatwindow:setText(foetext)
      UI:add(playercombatwindow)
      UI:add(foecombatwindow)
      UI:focus('screen')
    else
      UI:remove('combatwindow1')
      UI:remove('combatwindow2')
    end
  end

  function self.__accept:TileClicked (tile)
    if combat then
      UI:find("screen"):clearRange()
      self:addTask('CombatAnimation', combat)
    end
  end

  function self.__accept:Cancel ()
    if not combat then
      UI:find("screen"):clearRange()
      self:switch(battle.SelectActionActivity(UI, action))
    end
  end

  --[[ Tasks ]]-----------------------------------------------------------------

  function self.__task:CombatAnimation ()
    local log = combat:fight()
    for i,strike in ipairs(log) do
      self:sendEvent 'ShowStrikeAnimation' (strike)
      self:yield('StrikeAnimationFinished')
    end
    combat:cleanDead()
    action:finish()
    self:switch(battle.IdleActivity(UI, action:getField()))
  end
end
