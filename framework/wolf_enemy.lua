local Collision_Sprite = require('sprite/collision_sprite')
love.graphics.setDefaultFilter('nearest', 'nearest', 1)
local wolf_frame_1 = love.graphics.newImage("images/dog/sprite_0.png")
local wolf_frame_2 = love.graphics.newImage("images/dog/sprite_1.png")
local wolf_frame_3 = love.graphics.newImage("images/dog/sprite_2.png")
local wolf_frame_4 = love.graphics.newImage("images/dog/sprite_3.png")
local Wolf_Enemy = Collision_Sprite:new()
local vector = require('hump.vector')
local Signal = require('hump.signal')

function Wolf_Enemy:init_shape(collider)
  self.shape = collider:rectangle(self.x,self.y,self:get_width(),self:get_height())
end

Wolf_Enemy.group = "enemy"
Wolf_Enemy.health = 20

Wolf_Enemy.sprite_frames = {wolf_frame_1,wolf_frame_2,wolf_frame_3,wolf_frame_4}
Wolf_Enemy:set_sprite(wolf_frame_1)
Wolf_Enemy.current_frame = 1
Wolf_Enemy.animation_duration = .25

function Wolf_Enemy:new(x, y)
  e = {}
  e.x = x
  e.y = y
  e.scalex = 4
  e.scaley = 4
  e.colliding = {}
  e.duration = 0
  e.anim_timer = 0
  e.speed = 200
  e.velocity = e.speed*(vector(1,1):normalized())
  setmetatable(e, self)
  self.__index = self
  return e
end

function Wolf_Enemy:next_frame()
  if self.current_frame == #self.sprite_frames then
    self.current_frame = 1
  else
    self.current_frame = self.current_frame + 1
  end
  self:set_sprite(self.sprite_frames[self.current_frame])
end

Wolf_Enemy:during_collide("barrier", function(self,other,delta)
  self:move(delta.x,delta.y)
end)
Wolf_Enemy:during_collide("enemy", function(self,other,delta)
  self:move(delta.x,delta.y)
end)

Wolf_Enemy:on_collide("player_bullet", function(self,other,delta)
  self.health = self.health - 1
  if self.health <= 0 then
    self:delete()
  end
end)

function Wolf_Enemy:update(dt)
  self.anim_timer = self.anim_timer + dt
  if self.anim_timer > self.animation_duration then
    self:next_frame()
    self.anim_timer = self.anim_timer - self.animation_duration
  end
  if self.scalex * self.velocity.x < 0 then
    self:reflect_horizontal()
  end
  self:move(self.velocity.x*dt,self.velocity.y*dt)
end

function Wolf_Enemy:target_player(x,y)
  local cx, cy = self:get_center()
  self.velocity = self.speed*(vector(x - cx, y - cy):normalized())
end

function Wolf_Enemy:register_signals()
  self.messenger:register('player_location',function(x,y)
    self:target_player(x,y)
  end)
end

return Wolf_Enemy
