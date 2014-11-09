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

--- LUX's functional programming module.
-- Some functional programming tools lay around here.
local functional = {}

--- Binds a function's first parameter to the given argument.
--
-- @param f
-- function being bound.
--
-- @param arg
-- The bound argument.
--
-- @return
-- A function that, upon being called, does the same as f, but requires only
-- the arguments beyond the first one.
function functional.bindFirst (f, arg)
  local up = arg
  return function (...)
    return f(up, ...)
  end
end

--- Binds a function to the given (left-most) arguments.
-- The arguments must be passed in the apropriate order, according to the
-- function's specification.
--
-- @param f
-- The function being binded.
--
-- @param arg1
-- The first bound argument.
--
-- @param ...
-- The remaining bound arguments, in order.
--
-- @return
-- A function that, upon being called, does the same as f, but requires only the
-- remaining right-most arguments that were not binded with it.
function functional.bindLeft (f, arg1, ...)
  if select('#', ...) == 0 then
    return functional.bindFirst(f, arg1)
  else
    return functional.bindLeft(bindFirst(f, arg1), ...)
  end
end

--- Creates a <code>n</code>-curried function based on <code>f</code>.
--
-- @usage
-- local result = std.curry(print,2)
-- result (arg1) (arg2) (arg3, arg4, ...)
--
-- @param f The function being curried.
--
-- @param n How much the function should be curried.
--
-- @return An <code>n</code>-curried version of <code>f</code>.
function functional.curry (f, n)
  n = n or 1
  return function (...)
    local first, second = ...
    if n >= 1 and not second then
      if first then
        return functional.chain(bindLeft(f, first), n-1)
      else
        return functional.chain(f, n)
      end
    else
      return f(...)
    end
  end
end

local function doReverse (r, a, ...)
  if not a and select('#', ...) == 0 then
    return r()
  end
  local function aux ()
    return a, r()
  end
  return doReverse(aux, ...)
end

--- Reverses the order of the arguments.
-- @param ... Arbitrary arguments.
-- @return The arguments in reversed order.
function functional.reverse (...)
  return doReverse(function () end, ...)
end

--- Map function. Might overflow the stack and is not tail recursive.
--  @param f An unary function
--  @param a First mapped element
--  @param ... Other to-be-mapped elements
--  @return All the results of applying f to the given elements one by one.
function functional.map (f, a, ...)
  if not a and select('#', ...) == 0 then
    return -- empty list of elements
  else
    return f(a), map(f, ...)
  end
end

--- Expand a value into a value list: value, value, ...
--  @param n The number of times to expand.
--  @param value The expanded value
--  @param ... For internal use inly.
--  @return A list of copies of value.
function functional.expand (n, value, ...)
  if n <= 0 then return ... end
  return functional.expand(n-1, value, value, ...)
end

return functional

