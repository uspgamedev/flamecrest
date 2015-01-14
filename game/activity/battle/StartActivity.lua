
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
local Team      = class.package 'domain.battle' .Team

function battle:StartActivity (UI)

  engine.Activity:inherit(self)

  function self.__accept:Load ()
    local battlefield = Field(15, 15)
    local teams       = {
      Team('Blue', {0, 80, 255, 255}),
      Team('Red', {255, 80, 0, 255})
    }
    local units       = {
      UnitState(Unit("Leeroy Jenkins", true, spec:new{}, spec:new{}), teams[1]),
      UnitState(Unit("Juaum MacDude", true, spec:new{}, spec:new{}), teams[2]),
      UnitState(Unit("Yohannes MacDude", true, spec:new{}, spec:new{}), teams[2])
    }
    local lancespec = wpnspec:new{ typename='lance'}
    local swordspec = wpnspec:new{ typename='sword'}
    units[1]:setWeapon(Weapon('Iron Lance', lancespec))
    units[2]:setWeapon(Weapon('Iron Sword', swordspec))
    units[3]:setWeapon(Weapon('Iron Sword', swordspec))
    battlefield:putUnit(hexpos:new{1,1}, units[1])
    battlefield:putUnit(hexpos:new{6,5}, units[2])
    battlefield:putUnit(hexpos:new{5,6}, units[3])
    battlefield:setTeams(teams[1], teams[2])
    local screen = battleui.ScreenElement("screen", battlefield)
    local stats = ui.TextElement("stats", "", 18,
                                 vec2:new{16, screen:getHeight()-120-16},
                                 vec2:new{256, 120}, 'left')
    UI:add(screen)
    UI:add(stats)
    screen:lookAt(6, 6)
    self:switch(battle.PlayActivity(battlefield, units),
                battle.IdleActivity(UI, battlefield),
                battle.UIActivity(UI))
  end

end
