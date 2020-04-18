HC = require 'HC'

Room = {objects = {}, sprites = {}}
Room.sprite_canvas = nil

function Room:new(r)
  r = r or {}
  r.collider = HC.new()
  setmetatable(r, self)
  self.__index = self
  return r
end

function Room:update(dt)
  self:special_update(dt)
  for _, obj in pairs(self.objects) do
    obj:update(dt)
  end
  for _, sprite in pairs(self.sprites) do
    sprite:update(dt)
    if sprite.shape ~= nil then
      for shape, delta in pairs(self.collider:collisions(sprite.shape)) do
        sprite:collide_with(shape.sprite, delta.x, delta.y)
      end
    end
  end
end

function Room:special_update(dt)
end

function Room:draw(dt)
  love.graphics.setColor(1,1,1)
  for _, sprite in pairs(self.sprites) do
    sprite:draw(0,0,dt)
  end
end

function Room:insert_sprite(sprite)
  local p = #(self.sprites) + 1
  self.sprites[p] = sprite
  sprite:set_room(room, p)
  if sprite.init_shape ~= nil then
    sprite:init_shape(self.collider)
    sprite:connect_shape()
  end
end

return Room
