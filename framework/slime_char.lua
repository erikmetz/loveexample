local Collision_Sprite = require('collision_sprite')
local Player_Bullet = require("player_bullet")
local Gamestate = require("hump.gamestate")

local Slime_Char = Collision_Sprite:new()
local slime = love.graphics.newImage("Slime.png")
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

function Slime_Char:_keypressed(key, scancode, isrepeat)
  local cx,cy = self:get_center()
  local bspeed = 400
  if key == 'up' then
    self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,{x=0,y=-1},bspeed))
  elseif key == 'right' then
    self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,{x=1,y=0},bspeed))
  elseif key == 'down' then
    self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,{x=0,y=1},bspeed))
  elseif key == 'left' then
    self.room:insert_collision_sprite(Player_Bullet:new(cx,cy,{x=-1,y=0},bspeed))
  end
end

Slime_Char:on_collide("enemy", function(self,other,delta)
  self:delete()
end)

function Slime_Char:on_delete()
  if self.death_state ~= nil then
    Gamestate.switch(self.death_state)
  end
end

return Slime_Char
