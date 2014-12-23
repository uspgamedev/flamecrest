
local function bfs(battlefield, startpos)
   local resp = {}
   for i = 1,battlefield:getHeight() do
      resp[i] = {}
      for j = 1,battlefield:getWidth() do
        resp[i][j] = false
      end
   end
   local unit = battlefield:getTileAt(startpos):getUnit()
   local queue = { { startpos, 0 } }
   local maxdist = unit:getMv()
   while #queue > 0 do
      local pos, d = unpack(table.remove(queue, 1))
      if d <= maxdist then
         if (not resp[pos.i][pos.j] or resp[pos.i][pos.j] > d) then
            resp[pos.i][pos.j] = d
            local neighbors = pos:adjacentPositions()
            for _,neighbor in ipairs(neighbors) do
               if neighbor.i >= 1 and neighbor.i <= battlefield:getHeight() and
                  neighbor.j >= 1 and neighbor.j <= battlefield:getWidth() then
                  local curtile = battlefield:getTileAt(neighbor)
                  if curtile then
                     local curdist = unit:getTerrainCostFor(curtile:getType())
                     table.insert(queue, {neighbor, d+curdist})
                  end
               end
            end
         end
      end
   end
   return resp
end

return bfs
