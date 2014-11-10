
module ("model.battle", package.seeall) do
  
  function breadthfirstsearch(map, unit, startpos)
     local resp = {}
     for i = 1, map.height do
        resp[i] = {}
     end
     local queue = { { startpos, 0 } }
     local maxdist = unit.attributes.mv
     while #queue > 0 do
        local pos, d = unpack(table.remove(queue, 1))
        if d <= maxdist then
           if (not resp[pos.i][pos.j] or resp[pos.i][pos.j] > d) then
              resp[pos.i][pos.j] = d
              local neighbors = pos:adjacent_positions() 
              for _,neighbor in ipairs(neighbors) do
                 if neighbor.i >= 1 and neighbor.i <= map.height and
                    neighbor.j >= 1 and neighbor.j <= map.width then
                    local curtile = map:tile(neighbor)
                    if curtile then
                       local curdist = unit:terraincost(curtile.type)
                       table.insert(queue, {neighbor, d+curdist})
                    end
                 end
              end
           end
        end
     end
     return resp
  end
   
end
