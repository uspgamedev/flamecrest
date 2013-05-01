
module ("ui.battle.controller", package.seeall) do

  require 'ui.layout'
  require 'ui.common.dialog'
  require "ui.battle.cursor"
  require "common.vec2"
  require "model.battle.hexpos"
  require "model.battle.pathfinding"

  local floor         = math.floor
  local vec2          = vec2
  local hexpos        = model.battle.hexpos
  local cursor        = ui.battle.cursor
  local confirm_event = {}

  local function screentohexpos (origin, mousepos)
    local relpos = mousepos-origin
    local focus = hexpos:new {}
    relpos = relpos.x/192*vec2:new{1,-1} + relpos.y/64*vec2:new{1,1}
    focus.i = floor(relpos.y+0.5)
    focus.j = floor(relpos.x+0.5)
    local x,y = relpos.x-focus.j+0.5, relpos.y-focus.i+0.5
    if y > 2*x + 0.5 or y > x/2 + 0.75 then
      if x + y < 1 then
        focus.j = focus.j-1
      else
        focus.i = focus.i+1
      end
    elseif x > 2*y + 0.5 or x > y/2 + 0.75 then
      if x + y < 1 then
        focus.i = focus.i-1
      else
        focus.j = focus.j+1
      end
    end
    return focus
  end

  function movecursor (map, origin, pos, dt)
    cursor.move(map, screentohexpos(origin, pos), dt)
  end
  
  function confirm_event.select (mapscene, tile_hexpos, tile)
    local focus = tile.unit and tile_hexpos or nil
    if focus then
      -- FAZER UMA BUSCA EM LARGURA AQUI
      -- NA VERDADE NAO AQUI, MAS SABE COMO E'
      focus.paths = model.battle.breadthfirstsearch(mapscene.controller.map, tile.unit, tile_hexpos)
      return focus, "move"
    else
      return mapscene.focus, mapscene.mode
    end
  end

  function confirm_event.move (mapscene)
    mapscene.controller:moveunit(mapscene.focus, cursor.pos())
    return nil, "select"
  end

  function confirm_event.action ()
    return nil, "select"
  end

  function confirm_event.fight (mapscene)
    mapscene.controller:startcombat(mapscene.focus, cursor.pos())
    return nil, "select"
  end

  function confirm (mapscene, pos)
    local tile_hexpos   = screentohexpos(mapscene.origin, pos)
    local tile          = mapscene.controller.map:tile(tile_hexpos)
    print("confirm: " .. mapscene.mode)
    if tile then
      return confirm_event[mapscene.mode](mapscene, tile_hexpos, tile)
   end
    return mapscene.focus, mapscene.mode
  end
  
  function cancel ()
    return nil, "select"
  end

  local keyactions = { released = {} }

  function keyactions.released.escape ()
    --event.push "quit"
  end

  keyactions.released["return"] = function ()
    local attacker  = layout:focusedunit()
    local target    = layout:targetedunit()
    if not attacker or not target then return end
    if attacker:isdead() or target:isdead() then return end
    local distance  = layout.map:selectiondistance()
    if distance < attacker.weapon.minrange
      or distance > attacker.weapon.maxrange then
      return
    end
    fight(attacker, target, distance)
  end

  function keyactions.released.m ()
    layout.map:moveunit()
  end

  function keyactions.released.tab ()
    --game.changetolayout "combat"
  end

end
