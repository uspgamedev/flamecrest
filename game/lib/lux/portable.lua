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

--- This module allows for portable programming in Lua.
-- It currently support versions 5.1 and 5.2.
local portable = {}

local lambda = require 'lux.functional'

local lua_major, lua_minor = (function (a,b)
  return tonumber(a), tonumber(b)
end) (_VERSION:match "(%d+)%.(%d+)")

assert(lua_major >= 5) -- for sanity

local env_stack = {}
local push = table.insert
local pop = table.remove

local function getEnv ()
  if lua_minor <= 1 then
    return getfenv()
  else
    return _ENV
  end
end

local function setEnv (env)
  if lua_minor <= 1 then
    setfenv(0, env)
  else
    _ENV = env
  end
end

portable.getEnv = getEnv
portable.setEnv = setEnv

function portable.isVersion(major, minor)
  return major == lua_major and minor == lua_minor
end

function portable.pushEnvironment (env)
  push(env_stack, getEnv())
  setEnv(env)
end

function portable.popEnvironment ()
  setEnv(pop(env_stack))
end

if lua_minor <= 1 then
  table.unpack = unpack
end

--- Re-loads a funcion with the given env and an optional chunk name.
-- It is important to note that the reloaded funcion loses its closure.
-- @function loadWithEnv
-- @param f The original function
-- @param env The new environment
-- @param[opt] source The reloaded funciton chunk name
if lua_minor <= 1 then
  function portable.loadWithEnv(f, env, source)
    local loaded, err =  loadstring(string.dump(f, source))
    if not loaded then return nil, err end
    return setfenv(loaded, env)
  end
else
  function portable.loadWithEnv(f, env, source)
    return load(string.dump(f), source, 'b', env)
  end
end

return portable

