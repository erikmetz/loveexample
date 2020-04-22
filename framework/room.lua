local HC = require 'HC'
local Signal = require("hump.signal")

local Room = {objects = {}, sprites = {}, collision_sprites = {}}

function Room:new(r)
  r = r or {objects = {}, sprites = {}, collision_sprites = {}, to_delete = {}}
  r.messenger = Signal.new()
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


  for i, sprite in pairs(self.collision_sprites) do
    sprite:update(dt)
  end

  for id, sprite in pairs(self.collision_sprites) do
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

  for sprite, _ in pairs(self.to_delete) do
    self.to_delete[sprite] = nil
    sprite:_delete()
  end
end

function Room:_keypressed(key,scancode,isrepeat)
  for _, obj in pairs(self.objects) do
    obj:_keypressed(key,scancode,isrepeat)
  end
  for _, sprite in pairs(self.sprites) do
    sprite:_keypressed(key,scancode,isrepeat)
  end
  for _, collision_sprite in pairs(self.collision_sprites) do
    collision_sprite:_keypressed(key,scancode,isrepeat)
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
  sprite:set_room(self, self.sprites, p)
  if sprite.init_shape ~= nil then
    sprite:init_shape(self.collider)
    sprite:connect_shape()
  end
  sprite:register_messenger(self.messenger)
end

function Room:insert_collision_sprite(collision_sprite)
  local p = #(self.collision_sprites) + 1
  self.collision_sprites[p] = collision_sprite
  collision_sprite:set_room(self, self.collision_sprites, p)
  collision_sprite:init_shape(self.collider)
  collision_sprite.shape.sprite = collision_sprite
  collision_sprite:set_collider(self.collider)
  collision_sprite:connect_shape()
  collision_sprite:register_messenger(self.messenger)
end

return Room
