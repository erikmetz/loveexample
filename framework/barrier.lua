local Collision_Sprite = require('collision_sprite')

local Barrier = Collision_Sprite:new()
Barrier.group = "barrier"

function Barrier:new(x,y,w,h)
  b = {}
  b.x = x
  b.y = y
  b.width = w
  b.height = w

  setmetatable(b, self)
  self.__index = self
  return b
end

function Barrier:draw(screen_x, screen_y, dt)
end

return Barrier
