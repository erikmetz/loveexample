Sprite = require('sprite')
HC = require('HC')

Collision_Sprite = Sprite:new()
Collision_Sprite._on_collide = {}
Collision_Sprite._during_collide = {}
Collision_Sprite._stop_collide = {}
Collision_Sprite.colliding = {}
Collision_Sprite.collider = nil

function Collision_Sprite:new(o)
  o = o or {}
  o._on_collide = {}
  for k,v in pairs(self._on_collide) do
    o._on_collide[k] = v
  end
  o._during_collide = {}
  for k,v in pairs(self._during_collide) do
    o._during_collide[k] = v
  end
  o._stop_collide = {}
  for k,v in pairs(self._stop_collide) do
    o._stop_collide[k] = v
  end
  o.colliding = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Collision_Sprite:on_collide(group, reaction)
  self._on_collide[group] = reaction
end

function Collision_Sprite:during_collide(group, reaction)
  self._during_collide[group] = reaction
end

function Collision_Sprite:stop_collide(group, reaction)
  self._stop_collide[group] = reaction
end

function Collision_Sprite:update_collisions()
  for k,v in pairs(self.colliding) do
    if v == 2 then
      self:on_collide_with(k)
      self:during_collide_with(k)
      self.colliding[k] = 0
    elseif v == 1 then
      self:during_collide_with(k)
      self.colliding[k] = 0
    else
      self:stop_collide_with(k)
      self.colliding[k] = nil
    end
  end
end

function Collision_Sprite:init_shape(collider)
  self.shape = collider:point(self.x, self.y)
end

function Collision_Sprite:connect_shape()
  if self.shape == nil then
    print("error: shape does not exist")
  else
    self.shape.sprite = self
  end
end

function Collision_Sprite:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
  self.shape:move(dx,dy)
end

local function null_func()
end

function Collision_Sprite:on_collide_with(other)
  (self._on_collide[other.group] or self._on_collide["*"] or null_func)(self, other)
end

function Collision_Sprite:during_collide_with(other)
  (self._during_collide[other.group] or self._during_collide["*"] or null_func)(self, other)
end

function Collision_Sprite:stop_collide_with(other)
  (self._stop_collide[other.group] or self._stop_collide["*"] or null_func)(self, other)
end

function Collision_Sprite:set_collider(collider)
  self.collider = collider
end

function Collision_Sprite:delete()
  self:on_delete()
  if self.collider ~= nil then
    self.collider:remove(self.shape)
  end
  self.room_table[self.room_index] = nil
end

return Collision_Sprite
