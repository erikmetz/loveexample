local Collision_Sprite = require('sprite/collision_sprite')
local Player_Bullet = require("sprite/player_bullet")
local Gamestate = require("hump.gamestate")
local vector = require("hump.vector")

local Slime_Char = Collision_Sprite:new()
local slime = love.graphics.newImage("images/Slime.png")
Slime_Char:set_sprite(slime)
Slime_Char.velocity = vector(0,0)
Slime_Char.max_speed = 220
Slime_Char.accel = 2500
Slime_Char.shot_speed = 400
Slime_Char.group = "player"
Slime_Char.reload_time = .25
Slime_Char.reload_timer = 1000

function Slime_Char:update(dt)
  local moving_h = false
  local moving_v = false
  local cx,cy = self:get_center()
  self.reload_timer = self.reload_timer + dt
  if love.keyboard.isDown('w') then
    self.velocity.y = self.velocity.y - self.accel*dt
    moving_v = true
  end
  if love.keyboard.isDown('a') then
    self.velocity.x = self.velocity.x- self.accel*dt
    moving_h = true
  end
  if love.keyboard.isDown('s') then
    self.velocity.y = self.velocity.y + self.accel*dt
    moving_v = true
  end
  if love.keyboard.isDown('d') then
    self.velocity.x = self.velocity.x + self.accel*dt
    moving_h = true
  end
  if not moving_h then
    self.velocity.x = 0
  end
  if not moving_v then
    self.velocity.y = 0
  end
  if self.velocity:len() > self.max_speed then
    self.velocity = self.max_speed * self.velocity:normalized()
  end
  self:move((self.velocity*dt):unpack())

  if love.keyboard.isDown('up') then
    if self.reload_timer > self.reload_time then
      self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,self.velocity/2 + vector(0,-self.shot_speed)))
      self.reload_timer = 0
    end
  end
  if love.keyboard.isDown('right') then
    if self.reload_timer > self.reload_time then
      self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,self.velocity/2 + vector(self.shot_speed, 0)))
      self.reload_timer = 0
    end
  end
  if love.keyboard.isDown('down') then
    if self.reload_timer > self.reload_time then
      self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,self.velocity/2 + vector(0,self.shot_speed)))
      self.reload_timer = 0
    end
  end
  if love.keyboard.isDown('left') then
    if self.reload_timer > self.reload_time then
      self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,self.velocity/2 + vector(-self.shot_speed, 0)))
      self.reload_timer = 0
    end
  end

  self.messenger:emit('player_location', cx, cy)
end

function Slime_Char:_keypressed(key, scancode, isrepeat)
end

Slime_Char:on_collide("enemy", function(self,other,delta)
  self:delete()
end)

Slime_Char:during_collide("barrier", function(self,other,delta)
  self:move(delta.x,delta.y)
end)

function Slime_Char:on_delete()
  if self.death_state ~= nil then
    Gamestate.switch(self.death_state)
  end
end

return Slime_Char
