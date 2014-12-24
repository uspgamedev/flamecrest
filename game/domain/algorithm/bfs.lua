
local Queue = require 'engine.Queue'

local function bfs(battlefield, startpos)
   local resp = {}
   for i = 1,battlefield:getHeight() do
      resp[i] = {}
      for j = 1,battlefield:getWidth() do
        resp[i][j] = false
      end
   end
   local unit = battlefield:getTileAt(startpos):getUnit()
   local queue = Queue(10*battlefield:getWidth()*battlefield:getHeight())
   queue:push { startpos, 0 }
   local maxdist = unit:getStepsLeft()
   while not queue:isEmpty() do
      local pos, d = unpack(queue:pop())
      if d <= maxdist then
         if (not resp[pos.i][pos.j] or resp[pos.i][pos.j] > d) then
            resp[pos.i][pos.j] = d
            local neighbors = pos:adjacentPositions()
            for _,neighbor in ipairs(neighbors) do
               if battlefield:contains(neighbor) then
                  local curtile = battlefield:getTileAt(neighbor)
                  if curtile then
                     local curdist = unit:getTerrainCostFor(curtile:getType())
                     queue:push {neighbor, d+curdist}
                  end
               end
            end
         end
      end
   end
   return resp
end

return bfs
