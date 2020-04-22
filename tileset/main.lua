-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "Simple-Tiled-Implementation/sti"

function love.load()
	-- Load a map exported to Lua from Tiled
	map = sti("test_tilemap2.lua")
end

function love.update(dt)
	map:update(dt)
end

function love.draw()
	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	map:draw(50, 20, 3, 3)
end
