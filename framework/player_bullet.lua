local Collision_Sprite = require("collision_sprite")
local vector = require("hump.vector")

local Player_Bullet = Collision_Sprite:new()
Player_Bullet.group = "player_bullet"
Player_Bullet.radius = 4
function Player_Bullet:new(x,y,velocity)
  local b = {}
  b.x = x
  b.y = y
  b.velocity = velocity
  setmetatable(b, self)
  self.__index = self
  b:init_colliding()
  return b
end

function Player_Bullet:update(dt)
  self:move((dt*self.velocity):unpack())
end

function Player_Bullet:get_center()
  return self.x, self.y
end

Player_Bullet:on_collide("barrier", function(self, other, delta)
  self:delete()
end)

Player_Bullet:on_collide("enemy", function(self, other, delta)
  self:delete()
end)

function Player_Bullet:draw()
  love.graphics.setColor(1, 0, 0)
  local cx, cy = self:get_center()
  love.graphics.circle('fill', cx, cy, self.radius)
  love.graphics.setColor(1,1,1)
end

function Player_Bullet:on_delete()
end

function Player_Bullet:init_shape(collider)
  local cx, cy = self:get_center()
  self.shape = collider:circle(cx, cy,self.radius)
end

return Player_Bullet
