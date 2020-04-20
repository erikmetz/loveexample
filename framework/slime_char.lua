Collision_Sprite = require('collision_sprite')

abc = 5

Slime_Char = Collision_Sprite:new()
slime = love.graphics.newImage("Slime.png")
Slime_Char:set_sprite(slime)

Slime_Char.speed = 200

Slime_Char.group = "player"

function Slime_Char:update(dt)
  if love.keyboard.isDown('w') then
    self:move(0,-self.speed*dt)
  end
  if love.keyboard.isDown('a') then
    self:move(-self.speed*dt,0)
  end
  if love.keyboard.isDown('s') then
    self:move(0,self.speed*dt)
  end
  if love.keyboard.isDown('d') then
    self:move(self.speed*dt,0)
  end
end

function Slime_Char:init_shape(collider)
  self.shape = collider:rectangle(self.x,self.y,self:get_width(),self:get_height())
  self.shape.sprite = self
end


return Slime_Char
