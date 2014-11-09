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


--- This class represents a macro configuration.
-- @classmod macro.Specification
local Specification = require 'lux.oo.prototype' :new {}

local functional = require 'lux.functional'

local function directiveIterator (str)
  local yield = coroutine.yield
  for input, mod, directive, tail in str:gmatch "(.-)%$(%p)(.-)(%p?[%$\n])" do
    assert(tail == "\n" or tail == mod.."$")
    yield(input, mod, directive, #input + 1 + #mod + #directive + #tail)
  end
end

function Specification:iterateDirectives (str)
  return coroutine.wrap(functional.bindLeft(directiveIterator, str))
end

return Specification

