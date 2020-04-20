local Object = {}

function Object:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Object:update(dt)
end

local Sprite = Object:new({x = 0, y = 0, sprite = nil})
Sprite.rotation = 0
Sprite.scalex = 1
Sprite.scaley = 1
Sprite.width = 0
Sprite.height = 0
Sprite.room = nil
Sprite.room_index = nil

function Sprite:set_sprite(sprite)
  self.sprite = sprite
  self.width = sprite:getWidth()
  self.height = sprite:getHeight()
end

function Sprite:reflect_horizontal()
  self.scalex = self.scalex*-1
  self.x = self.x - self:get_width()
end

function Sprite:set_scale_horizontal(s)
  self.scalex = s
end

function Sprite:set_reflection_horizontal(d)
  if d > 0 then
    self.scalex = math.abs(self.scalex)
  elseif d < 0 then
    self.scalex = -math.abs(self.scalex)
  end
end

function Sprite:draw(screen_x, screen_y, dt)
  love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scalex, self.scaley, screen_x, screen_y)
end

function Sprite:set_room(room, table, index)
  self.room = room
  self.room_table = table
  self.room_index = index
end

function Sprite:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

function Sprite:get_width()
  return self.width * self.scalex
end

function Sprite:get_height()
  return self.height * self.scaley
end

function Sprite:on_delete()
end

function Sprite:delete()
  self:on_delete()
  self.room_table[self.room_index] = nil
end

return Sprite
