
package.path = package.path..";./lib/?.lua"

local UI

function love.load ()
  UI = require 'engine.UI' ()
  UI:add(require 'engine.UIElement' ())
end

function love.draw ()
  UI:draw(love.graphics)
end
