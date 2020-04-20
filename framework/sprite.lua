local Object = {}

function Object:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Object:update(dt)
end

function Object:_keypressed(key, scancode, isrepeat)
end

local Sprite = Object:new({x = 0, y = 0, sprite = nil})
Sprite.rotation = 0
Sprite.scalex = 1
Sprite.scaley = 1
Sprite.width = 0
Sprite.height = 0
Sprite.room = nil
Sprite.room_index = nil

local function sign(x)
  if x > 0 then
    return 1
  elseif x < 0 then
    return -1
  else
    return 0
  end
end

function Sprite:set_sprite(sprite)
  self.sprite = sprite
  self.width = sprite:getWidth()
  self.height = sprite:getHeight()
end

function Sprite:reflect_horizontal()
  self.scalex = self.scalex*-1
  self.x = self.x - (sign(self.scalex) * self:get_width())
end

function Sprite:set_scale_horizontal(s)
  self.scalex = s
end

function Sprite:set_reflection_horizontal(d)
  if sign(d*self.scalex) < 1 then
    self:reflect_horizontal()
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

function Sprite:get_center()
  local cx = self.x + (self:get_width(true)/2)
  local cy = self.y + (self:get_height(true)/2)
  return cx, cy
end

function Sprite:get_width(signed)
  signed = signed or false
  if signed then
    return self.width * self.scalex
  else
    return math.abs(self.width * self.scalex)
  end
end

function Sprite:get_height(signed)
  signed = signed or false
  if signed then
    return self.height * self.scaley
  else
    return math.abs(self.height * self.scaley)
  end
end

function Sprite:on_delete()
end

function Sprite:delete()
  self:on_delete()
  self.room.to_delete[self] = true
end

function Sprite:_delete()
  self.room_table[self.room_index] = nil
end



return Sprite
