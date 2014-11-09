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

--- This module holds classes that represent streams of data.
--  @module stream
local stream = {}

local prototype = require 'lux.oo.prototype'

stream.Base = prototype:new {}

function stream.Base:write (data)
  error "Unimplemented abstract method"
end

function stream.Base:read (quantity)
  error "Unimplemented abstract method"
end

--------------------------------------------------------------------------------

stream.String = stream.Base:new {
  buffer = "",
  position = 1
}

function stream.String:write (data)
  self.buffer = self.buffer .. data
end

function stream.String:read (quantity)
  if type(quantity) == 'number' then
    local result = self.buffer:sub(self.position, self.position + quantity)
    self.position = self.position+#result
    return result
  elseif quantity == '*a' then
    return self:read(#self.buffer - self.position + 1)
  elseif quantity == '*l' then
    local line_end = self.buffer:find('\n', self.position, true)
    return self:read(line_end - self.position + 1)
  else
    error("Unexpected argument: "..quantity)
  end
end

--------------------------------------------------------------------------------

stream.File = stream.Base:new {
  loader = io.open,
  path = "",
  mode = "r"
}

function stream.File:__construct ()
  self.file = self.loader(self.path, self.mode)
end

function stream.File:write (data)
  self.file:write(tostring(data))
end

function stream.File:read (quantity)
  return self.file:read(quantity)
end

--------------------------------------------------------------------------------

return stream

