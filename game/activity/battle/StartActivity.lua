
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'
local spec      = require 'domain.unitspec'
local wpnspec   = require 'domain.weaponspec'
local hexpos    = require 'domain.hexpos'

local engine    = class.package 'engine'
local domain    = class.package 'domain'
local ui        = class.package 'ui'
local battleui  = class.package 'ui.battle'
local battle    = class.package 'activity.battle'

function battle:StartActivity (UI)

  engine.Activity:inherit(self)

  function self.__accept:Load ()
    local battlefield = domain.BattleField(15, 10)
    local units       = {
      domain.UnitState(domain.Unit("Leeroy Jenkins", true, spec:new{},
                                 spec:new{})),
      domain.UnitState(domain.Unit("Juaum MacDude", true, spec:new{}, spec:new{}))
    }
    units[1]:setWeapon(domain.Weapon('Iron Lance', wpnspec:new{}))
    units[2]:setWeapon(domain.Weapon('Iron Bow', wpnspec:new{ minrange=2,maxrange=2}))
    battlefield:putUnit(hexpos:new{1,1}, units[1])
    battlefield:putUnit(hexpos:new{5,5}, units[2])
    local screen = battleui.ScreenElement("screen", battlefield)
    local stats = ui.TextElement("stats", "", 18, vec2:new{16, 16}, vec2:new{256, 20})
    UI:add(screen)
    UI:add(stats)
    screen:lookAt(6, 6)
    self:switch(battle.PlayActivity(battlefield, units),
                battle.IdleActivity(UI, battlefield),
                battle.UIActivity(UI))
  end

end
