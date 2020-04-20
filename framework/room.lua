local HC = require 'HC'

local Room = {objects = {}, sprites = {}, collision_sprites = {}}

function Room:new(r)
  r = r or {objects = {}, sprites = {}, collision_sprites = {}}
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
  end
  for _, sprite in pairs(self.collision_sprites) do
    for shape, delta in pairs(self.collider:collisions(sprite.shape)) do
      if shape.sprite ~= sprite then
        if sprite.colliding[shape.sprite] == nil then
          sprite.colliding[shape.sprite] = {status = 2, separating_vector = delta}
        else
          sprite.colliding[shape.sprite] = {status = 1, separating_vector = delta}
        end
      end
    end
  end
  for i, sprite in pairs(self.collision_sprites) do
    sprite:update_collisions()
  end
  for i, sprite in pairs(self.collision_sprites) do
    sprite:update(dt)
  end
end

function Room:special_update(dt)
end

function Room:draw(dt)
  love.graphics.setColor(1,1,1)
  for _, sprite in pairs(self.sprites) do
    sprite:draw(0,0,dt)
  end
  for _, sprite in pairs(self.collision_sprites) do
    sprite:draw(0,0,dt)
  end
end

function Room:insert_sprite(sprite)
  local p = #(self.sprites) + 1
  self.sprites[p] = sprite
  sprite:set_room(room, self.sprites, p)
  if sprite.init_shape ~= nil then
    sprite:init_shape(self.collider)
    sprite:connect_shape()
  end
end

function Room:insert_collision_sprite(collision_sprite)
  local p = #(self.collision_sprites) + 1
  self.collision_sprites[p] = collision_sprite
  collision_sprite:set_room(room, self.collision_sprites, p)
  collision_sprite:init_shape(self.collider)
  collision_sprite.shape.sprite = collision_sprite
  collision_sprite:set_collider(self.collider)
  collision_sprite:connect_shape()
end

return Room
