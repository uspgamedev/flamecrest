
local class     = require 'lux.oo.class'
local vec2      = require 'lux.geom.Vector'
local spec      = require 'domain.common.unitspec'
local wpnspec   = require 'domain.common.weaponspec'
local hexpos    = require 'domain.common.hexpos'

local engine    = class.package 'engine'
local battledom = class.package 'domain.battle'
local ui        = class.package 'ui'
local battleui  = class.package 'ui.battle'
local battle    = class.package 'activity.battle'

local Unit      = class.package 'domain.common' .Unit
local Weapon    = class.package 'domain.common' .Weapon
local Field     = class.package 'domain.battle' .Field
local UnitState = class.package 'domain.battle' .UnitState

function battle:StartActivity (UI)

  engine.Activity:inherit(self)

  function self.__accept:Load ()
    local battlefield = Field(15, 15)
    local units       = {
      UnitState(Unit("Leeroy Jenkins", true, spec:new{}, spec:new{})),
      UnitState(Unit("Juaum MacDude", true, spec:new{}, spec:new{}))
    }
    units[1]:setWeapon(Weapon('Iron Lance', wpnspec:new{}))
    units[2]:setWeapon(Weapon('Iron Bow', wpnspec:new{ minrange=2,maxrange=2}))
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
