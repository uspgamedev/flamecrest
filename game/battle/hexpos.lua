
local object = require "lux.object"
require "vec2"

local type          = type
local getmetatable  = getmetatable
local rawget        = rawget
local rawset        = rawset
local unpack        = unpack
local max           = math.max
local abs           = math.abs
local floor         = math.floor
local vec2          = vec2

module "battle" do

  hexpos = object.new {}

  -- Vector coordinates.
  hexpos[1] = 0
  hexpos[2] = 0
  
  function hexpos:__index (k)
    if k == "i" then return self[1] end
    if k == "j" then return self[2] end
    return getmetatable(self)[k]
  end
  
  function hexpos:__newindex (k, v)
    if k == "i" then rawset(self, 1, v)
    elseif k == "j" then rawset(self, 2, v)
    else rawset(self, k, v) end
  end
  
  function hexpos.__add (lhs, rhs)
    return hexpos:new {
      lhs[1] + rhs[1],
      lhs[2] + rhs[2]
    }
  end
  
  function hexpos.__sub (lhs, rhs)
    return hexpos:new {
      lhs[1] - rhs[1],
      lhs[2] - rhs[2]
    }
  end
 
  function hexpos.__mul (lhs, rhs)
    if type(lhs) == "number" then
      return hexpos:new { lhs*rhs.j, lhs*rhs.i }
    elseif type(rhs) == "number" then
      return hexpos:new { rhs*lhs.j, rhs*lhs.i }
    end
  end

  function hexpos.__eq (lhs, rhs)
    return lhs.i == rhs.i and lhs.j == rhs.j
  end

  function hexpos.__lt (lhs, rhs)
    return lhs.i < rhs.i and lhs.j < rhs.j
  end

  function hexpos.__le (lhs, rhs)
    return lhs.i <= rhs.i and lhs.j <= rhs.j
  end

  function hexpos:size ()
    return self[1]*self[2] >= 0
      and max(abs(self[1]), abs(self[2]))
      or  abs(self[1]) + abs(self[2])
  end

  function hexpos:truncated ()
    return hexpos:new {floor(self[1]+0.5), floor(self[2]+0.5)}
  end

  function hexpos:get ()
    return unpack(self)
  end

  function hexpos:tovec2 ()
    return vec2:new{96*self.j-96*self.i, 32*self.j+32*self.i}
  end
 
  function hexpos:set (i, j)
    self[1] = i
    self[2] = j
  end
 
  function hexpos:add (p)
    self[1] = self[1] + p[1]
    self[2] = self[2] + p[2]
  end

  function hexpos:sub (p)
    self[1] = self[1] - p[1]
    self[2] = self[2] - p[2]
  end

end
