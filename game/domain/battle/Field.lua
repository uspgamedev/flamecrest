
local class   = require 'lux.oo.class'
local hexpos  = require 'domain.common.hexpos'
local bfs     = require 'domain.algorithm.bfs'

local battle  = class.package 'domain.battle'

local Tile    = battle.Tile

function battle:Field (width, height)

  local tiles   = {}
  local teams   = {}
  local turn    = 1

  for i=1,height do
    tiles[i] = {}
    for j=1,width do
      local t = (love.math.random() > .2) and 'plains' or 'forest'
      tiles[i][j] = Tile(hexpos:new{i,j}, t)
    end
  end

  function self:contains (pos)
    return hexpos:new{1,1} <= pos and pos <= hexpos:new{height, width}
  end

  function self:getTileAt (pos)
    pos = pos:rounded()
    return self:contains(pos) and tiles[pos.i][pos.j] or nil
  end

  function self:getWidth ()
    return width
  end

  function self:getHeight ()
    return height
  end

  function self:eachTile (action)
    for i = 1, height do
      for j = 1, width do
        local tile = tiles[i][j]
        if tile then
          action(i, j, tile)
        end
      end
    end
  end

  function self:putUnit (pos, unit)
    pos = pos:floor()
    if self:contains(pos) then
      tiles[pos.i][pos.j]:setUnit(unit)
    end
  end

  function self:getCurrentTeam ()
    return teams[turn]
  end

  function self:setTeams (team, ...)
    if team then
      table.insert(teams, team)
      return self:setTeams(...)
    end
  end

  function self:endTurn ()
    for i = 1, height do
      for j = 1, width do
        local tile = tiles[i][j]
        if tile then
          local unit = tile:getUnit()
          if unit and unit:getTeam() == self:getCurrentTeam() then
            unit:resetAction()
          end
        end
      end
    end
    turn = (turn % #teams) + 1
  end

  function self:hasAvailableUnits ()
    for i = 1, height do
      for j = 1, width do
        local tile = tiles[i][j]
        if tile then
          local unit = tile:getUnit()
          if unit and unit:getTeam() == self:getCurrentTeam()
                  and not unit:isUsed() then
            return true
          end
        end
      end
    end
    return false
  end

  function self:isOver ()
    local defeated = {}
    for _,team in ipairs(teams) do
      local check = false
      for i = 1,height do
        for j = 1,width do
          local tile = tiles[i][j]
          if tile then
            local unit = tile:getUnit()
            if unit and unit:getTeam() == team then
              check = true
            end
          end
        end
      end
      if not check then
        defeated[team] = true
      end
    end
    local count, winner = 0, nil
    for _,team in ipairs(teams) do
      if defeated[team] then
        count = count + 1
      else
        winner = team
      end
    end
    return count == #teams - 1 and winner
  end

end
