
require "nova.object"

module("vec2", nova.object.inherit()) do
  
  -- Vector coordinates.
  vec2[1] = 0
  vec2[2] = 0
  
  function vec2:__index (k)
    if k == "x" then return self[1] end
    if k == "y" then return self[2] end
    return getmetatable(self)[k]
  end
  
  function vec2:__newindex (k, v)
    if k == "x" then rawset(self, 1, v)
    elseif k == "y" then rawset(self, 2, v)
    else rawset(self, k, v) end
  end
  
  function vec2.__add (lhs, rhs)
    return vec2:new {
      lhs[1] + rhs[1],
      lhs[2] + rhs[2]
    }
  end
  
  function vec2.__sub (lhs, rhs)
    return vec2:new {
      lhs[1] - rhs[1],
      lhs[2] - rhs[2]
    }
  end
 
  function vec2.__mul (lhs, rhs)
    if type(lhs) == "number" then
      return vec2:new { lhs*rhs.x, lhs*rhs.y }
    elseif type(rhs) == "number" then
      return vec2:new { rhs*lhs.x, rhs*lhs.y }
    else -- assume both are vec2
      return lhs.x*rhs.x + lhs.y*rhs.y
    end
  end
 
  function vec2:set (x, y)
    self[1] = x
    self[2] = y
  end
 
  function vec2:add (v)
    self[1] = self[1] + v[1]
    self[2] = self[2] + v[2]
  end

  function vec2:sub (v)
    self[1] = self[1] - v[1]
    self[2] = self[2] - v[2]
  end
  
end

