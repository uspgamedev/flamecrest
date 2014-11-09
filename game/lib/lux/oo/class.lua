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

--- LUX's object-oriented feature module.
--  This module provides some basic functionalities for object-oriented
--  programming in Lua. It is divided in two parts, which you can @{require}
--  separately.
--
--  <h2><code>lux.oo.prototype</code></h2>
--
--  This part provides a prototype-based implementation. It returns the root
--  prototype object, with which you can create new objects using
--  @{prototype:new}. Objects created this way automatically inherit fields and
--  methods from their parent, but may override them. It is not possible to
--  inherit from multiple objects. For usage instructions, refer to
--  @{prototype}.
--
--  <h2><code>lux.oo.class</code></h2>
--
--  This part provides a class-based implementation. It returns a special table
--  @{class} through which you can define classes. As of the current version of
--  LUX, there is no support for inheritance.
--
--  @module lux.oo

--- A special table for defining classes.
--  By defining a named method in it, a new class is created. It uses the given
--  method to create its instances. Once defined, the class can be retrieved by
--  using accessing the @{class} table with its name.
--
--  Since the fields are declared in a scope of
--  their own, local variables are kept their closures. Thus, it is
--  possible to have private members. Public member can be created by not using
--  the <code>local</code> keyword or explicitly referring to <code>self</code>
--  within the class definition.
--
--  Inheritance is possible through a special field in the classes, 'inheritAs'.
--  You use it the same way you the declare classes with @{class}.
--
--  @feature class
--  @usage
--  local class = require 'lux.oo.class'
--  function class:MyClass()
--    local a_number = 42
--    function show ()
--      print(a_number)
--    end
--  end
--  function class.MyClass.inheritAs:MyChildClass()
--    local a_string = "foo"
--    function show_twice ()
--      show()
--      show()
--    end
--  end
--
local class = {}

local port              = require 'lux.portable'
local classes           = {}
local definition_scope  = {}
local no_op             = function () end

local function applyDefinition (the_class, obj)
  if not the_class then
    return
  else
    applyDefinition(the_class.parent, obj)
    assert(port.loadWithEnv(the_class.definition, obj)) (obj)
  end
end

local function construct (the_class, ...)
  local obj = setmetatable({ __class = the_class, __meta = {} }, definition_scope)
  applyDefinition(the_class, obj)
  setmetatable(obj, nil)
  obj.__meta.__index = obj.__meta.__index or _G
  if the_class.parent then
    obj.super = the_class.parent.constructor
  end
  -- Call constructor if available
  setmetatable(obj, obj.__meta);
  (the_class.constructor or no_op) (...)
  return obj
end

definition_scope.__index = _G

function definition_scope.__newindex (obj, key, value)
  if type(value) == 'function' then
    if key == obj.__class.name then
      obj.__class.constructor = value
      rawset(obj, key, function(...) return construct(obj.__class, ...) end)
    else
      rawset(obj, key, function(_, ...) return value(...) end)
    end
  end
end

function class:define (name, definition)
  assert(not classes[name], "Redefinition of class '"..name.."'")
  local new_class = {
    name = name,
    definition = definition
  }
  new_class.inheritAs = setmetatable({ owner = new_class }, { __newindex = class.define })
  if self ~= class then
    new_class.parent = self.owner
  end
  setmetatable(new_class, { __call = construct })
  classes[name] = new_class
end

function class:forName (name)
  return classes[name]
end

setmetatable(class, {
  __index     = class.forName,
  __newindex  = class.define
})

return class

