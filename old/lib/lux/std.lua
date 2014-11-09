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

--------
-- LUX's standard module.
-- Here a collection of general-purpose functions are available. This module is
-- also set up in a way that the global environment is accessible through it.
-- This allows you to change the current evironment to it add still have access
-- to the global default environment.
local std = {}

--- Prints all key-value pairs of the given table to the standard output.
--  @param t The table whose field are to be listed.
function std.ls (t)
  table.foreach(t, print)
end

--- Reads a Lua script as a data file.
--
--  Makes and returns a table containing everything that was created in the
--  global scope of that script.
--
--  @param path
--  The path to the data file.
--
--  @param loader
--  The function used to load the file. Default is Lua's @{load} function.
--
--  @return
--  The table representing the data file.
function std.loadDataFile (path, loader)
  loader = loader or load
  local file = loader(path)
  local data = {}
  package.seeall(data)
  setfenv(file, data) ()
  setmetatable(data, nil)
  return data
end

return setmetatable(std, { __index = _G })

