local Collision_Sprite = require('collision_sprite')
local wolf_down_img = love.graphics.newImage("wolf_down.png")
local wolf_frame_1 = love.graphics.newImage("threequarterswolfframe1.png")
local wolf_frame_2 = love.graphics.newImage("threequarterswolfframe2.png")
local Wolf_Enemy = Collision_Sprite:new()

function Wolf_Enemy:init_shape(collider)
  self.shape = collider:rectangle(self.x,self.y,self:get_width(),self:get_height())
end

Wolf_Enemy.sprite_frames = {wolf_frame_1,wolf_frame_2}
Wolf_Enemy:set_sprite(wolf_frame_1)
Wolf_Enemy.current_frame = 1
Wolf_Enemy.animation_duration = .25
Wolf_Enemy.dir_duration = 4

function Wolf_Enemy:new(x, y)
  e = {}
  e.x = x
  e.y = y
  e.duration = 0
  e.anim_timer = 0
  e.dir_timer = 0
  e.speed = 25
  --local tempx = 2*math.random() - 1
  --local tempy = 2*math.random() - 1
  local tempx = 1
  local tempy = 1
  e.direction = {}
  e.direction.x = (tempx) / math.sqrt(tempx^2 + tempy^2)
  e.direction.y = (tempy) / math.sqrt(tempx^2 + tempy^2)
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

function Wolf_Enemy:update(dt)
  self.anim_timer = self.anim_timer + dt
  self.dir_timer = self.dir_timer + dt
  if self.anim_timer > self.animation_duration then
    self:next_frame()
    self.anim_timer = self.anim_timer - self.animation_duration
  end
  if self.dir_timer > self.dir_duration then
    self:reflect_horizontal()
    self.direction.x = -self.direction.x
    self.dir_timer = self.dir_timer - self.dir_duration
  end
  self:move(self.speed * self.direction.x * dt, self.speed * self.direction.y * dt)
end

return Wolf_Enemy
