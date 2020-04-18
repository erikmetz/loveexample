Sprite = require('sprite')
HC = require('HC')

Collision_Sprite = Sprite:new()
Collision_Sprite._on_collide = {}

function Collision_Sprite:on_collide(group, reaction)
  self._on_collide[group] = reaction
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

function Collision_Sprite:collide_with(other, dx, dy)
  (self._on_collide[other.group] or self._on_collide["*"] or _NULL_)(self, other, dx, dy)
end

return Collision_Sprite
