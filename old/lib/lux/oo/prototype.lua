--[[
--
-- Copyright (c) 2013-2014 Wilson Kazuo Mizutani
--
-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
--    1. The origin of this software must not be misrepresented; you must not
--       claim that you wrote the original software. If you use this software
--       in a product, an acknowledgment in the product documentation would be
--       appreciated but is not required.
--
--    2. Altered source versions must be plainly marked as such, and must not be
--       misrepresented as being the original software.
--
--    3. This notice may not be removed or altered from any source
--       distribution.
--
--]]

--- @module lux.oo

--- The root prototype object.
--  @feature prototype
local prototype = {}

-- Recursive initialization.
local function init (obj, super)
  if not super then return end
  if super.__init then
    if type(super.__init) == "table" then
      for k,v in pairs(super.__init) do
        if not rawget(obj, k) then
          rawset(obj, k, prototype.clone(v))
        end
      end
    end
  end
  init(obj, super:__super())
  if super.__construct then
    if type(super.__construct) == "function" then
      super.__construct(obj)
    end
  end
end

--- Creates a new object from a prototype.
--  If the self object has a <code>__construct</code> field as a function, it
--  will be applied to the new object. If it has an <code>__init</code> field as
--  a table, its contents will be cloned into the new object.
--  @param object A table containing the object's fields.
--  @usage
--    object = prototype:new { x = 42, text = "cheese" }
function prototype:new (object)
  object = object or {}
  self.__index = rawget(self, "__index") or self
  setmetatable(object, self)
  init(object, self)
  return object;
end

--- Returns the parent of an object.
--  Note that this may get confusing if you use prototypes as classes, because
--  <code>obj:__super()</code> will most likely return the object's class, not
--  its class' parent class. In this case, it is better and more explicit to use
--  <code>Class:__super()</code> directly.
--  @return The object's parent.
function prototype:__super ()
  return getmetatable(self)
end

--- Binds a method call.
--  This is just an auxiliary method. Specially useful when you need to provide
--  a callback function as a method from a specific object.
--  @param method_name The name of the method being bound.
--  @return A function binding the given method to the object.
--  @usage
--  local object = prototype:new { x = 42 }
--
--  function object:get()
--    return x
--  end
--
--  local get1 = object:new{}:__bind 'get'
--  local get2 = object:new{ x = 1337 }:__bind 'get'
--
--  -- Will print "42 1337"
--  print(get1(), get2())
function prototype:__bind (method_name)
  return function (...)
    return self[method_name](self, ...)
  end
end

--- Clones the object.
--  Not to be confused with @{prototype:new}. This recursevely clones an object
--  and its fields. <strong>It may go into an infinite loop if there is a cyclic
--  reference inside the object</strong>. This function may also be used to
--  clone arbitrary Lua tables.
--  @return A clone of this object.
function prototype:clone ()
  if type(self) ~= "table" or self == prototype then return self end
  local cloned = {}
  for k,v in pairs(self) do
    cloned[k] = prototype.clone(v)
  end
  local super = prototype.__super(self)
  return super and super.new and super:new(cloned) or cloned
end

return prototype

