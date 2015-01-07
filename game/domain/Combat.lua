
local class = require 'lux.oo.class'

function class:Combat (attacker, defender)

  local function muchFaster ()
    return nil, nil
  end

  local function strike (atk, def)
    return {}
  end

  function self:fight ()
    local range = (attacker.tile:getPos() - defender.tile:getPos()):size()
    local exp = 1
    local log = {}
    local info = {
      [attacker] = {
        unit = attacker,
        dealtdmg = false,
        enemy = defender
      },
      [defender] = {
        unit = defender,
        dealtdmg = false,
        enemy = attacker
      }
    }
    local strike_result
    if attacker.unit:withinAtkRange(range) then
      table.insert(log, strike(attacker, defender))
    end
    if not defender.unit:isDead() and defender.unit:withinAtkRange(range) then
      table.insert(log, strike(defender, attacker))
    end
    if not attacker.unit:isDead() and not defender.unit:isDead() then
      local faster, slower = muchFaster()
      if (faster and faster.unit:withinAtkRange(range)) then
        table.insert(log, strike(faster.unit, slower.unit))
      end
    end
    -- One could generate the infotable from the log. That one is not me.
    log.deaths = {}
    log.exp    = {}
    --[[
    for _,v in pairs(info) do
      if v.dealtdmg then
        if v.enemy.unit:isdead() then
          exp = killexp(v.unit.unit, v.enemy.unit)
          table.insert(log.deaths, v.enemy.unit)
        else
          exp = combatexp(v.unit.unit, v.enemy.unit)
        end
      else
        exp = 1
      end
      v.unit.unit:gainexp(exp)
      if not v.unit.unit:isdead() then
        log.exp[v.unit.unit] = exp
      end
    end
    ]]
    return log
  end

end

return class:bind 'Combat'
