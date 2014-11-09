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

--- LUX's testing module.
module ('lux.test', package.seeall)

local term = require 'lux.terminal'
local port = require 'lux.portable'

--- Runs an unit test.
function unit (unit_name)
  local tests = {}
  local test_mttab = { __newindex = tests, __index = _G }
  local unit_script = "test/units/"..string.gsub(unit_name, "%.", "/")..".lua"
  local script, err = loadfile(unit_script)
  if not script then
    print(err)
  end
  script = port.loadWithEnv(script, setmetatable({}, test_mttab), 'unit_name') ()
  local before = tests.before or function () end
  for key,case in pairs(tests) do
    local name = string.match(key, "^test_([%w_]+)$")
    if type(case) == 'function' and name then
      before()
      local check, err = pcall(case)
      if check then
        term.write("<bright><green>[Success]<clear> ")
      else
        term.write("<bright><red>[Failure]<clear> ")
      end
      term.write("<bright>"..unit_name.."."..name.."<clear>\n")
      if err then term.line(err) end
    end
  end
end

