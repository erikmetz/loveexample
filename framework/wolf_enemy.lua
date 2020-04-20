local Collision_Sprite = require('collision_sprite')
local wolf_down_img = love.graphics.newImage("wolf_down.png")
local Wolf_Enemy = Collision_Sprite:new()

Wolf_Enemy:set_sprite(wolf_down_img)
function Wolf_Enemy:init_shape(collider)
  self.shape = collider:rectangle(self.x,self.y,self:get_width(),self:get_height())
end

function Wolf_Enemy:new(x, y)
  e = {}
  e.x = x
  e.y = y
  e.duration = 0
  e.speed = 50
  local tempx = 2*math.random() - 1
  local tempy = 2*math.random() - 1
  e.direction = {}
  e.direction.x = (tempx) / math.sqrt(tempx^2 + tempy^2)
  e.direction.y = (tempy) / math.sqrt(tempx^2 + tempy^2)
  setmetatable(e, self)
  self.__index = self
  return e
end

function Wolf_Enemy:update(dt)
  self.duration = self.duration + dt
  if self.duration > 1 then
    self:reflect_horizontal()
    self.duration = self.duration - 1
  end
  self:move(self.speed * self.direction.x * dt, self.speed * self.direction.y * dt)
end

return Wolf_Enemy
