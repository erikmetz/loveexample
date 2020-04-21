
local Room = require("room")
local Sprite = require("sprite/sprite")
local Collision_Sprite = require("sprite/collision_sprite")
local Slime_Char = require("sprite/slime_char")
local Wolf_Enemy = require("sprite/wolf_enemy")
local Barrier = require("barrier")

local Gamestate = require("hump.gamestate")

local game = {}
local gameover = {}

math.randomseed(os.time())

function game:enter()
  local slime = love.graphics.newImage("images/Slime.png")
  local Slime_sprite = Collision_Sprite:new()
  Slime_sprite:set_sprite(slime)
  Slime_sprite.velocity = 10
  Slime_sprite.direction = {x=1, y=0}
  function Slime_sprite:init_shape(collider)
    collider:rectangle(self.x, self.y, self:get_width(), self:get_height())
  end

  Slime_sprite:on_collide("*", function(self,other)
    self.direction.x = -self.direction.x
    self.direction.y = -self.direction.y
  end)

  Slime_sprite:on_collide("player", function(self,other)
    self:delete()
  end)

  function Slime_sprite:update(dt)
    self:move(self.velocity * self.direction.x * dt, self.velocity * self.direction.y * dt)
  end

  function Slime_sprite:init_shape(collider)
    self.shape = collider:rectangle(self.x,self.y,self:get_width(),self:get_height())
    self.shape.sprite = self
  end

  function Slime_sprite:init(k)
    self.velocity = math.random()*100
    local tempx = math.random()
    local tempy = math.random()
    self.direction = {}
    self.direction.x = (tempx) / math.sqrt(tempx^2 + tempy^2)
    self.direction.y = (tempy) / math.sqrt(tempx^2 + tempy^2)
    self.x = 50 * math.floor(k / 10)
    self.y = 50 * (k % 10)
  end

  function Slime_sprite:on_delete()
    print("O I am slain")
  end

  test_room = Room:new()
--[[
  for i = 1, 100 do
    local slime_instance = Slime_sprite:new()
    slime_instance:init(i)
    test_room:insert_collision_sprite(slime_instance)
  end
  test_room:insert_collision_sprite(Barrier:new(0,100,600,10))
  --]]
  test_room:insert_collision_sprite(Barrier:new(0,-100,800,100))
  test_room:insert_collision_sprite(Barrier:new(-100,0,100,600))
  test_room:insert_collision_sprite(Barrier:new(0,600,800,100))
  test_room:insert_collision_sprite(Barrier:new(800,0,100,600))
  test_room:insert_collision_sprite(Wolf_Enemy:new(300,1))
  test_room:insert_collision_sprite(Wolf_Enemy:new(0,300))
  test_room:insert_collision_sprite(Wolf_Enemy:new(760,300))
  local slime_char_instance = Slime_Char:new({x = 550, y = 550})
  slime_char_instance.death_state = gameover
  test_room:insert_collision_sprite(slime_char_instance)


end


function game:update(dt)
  test_room:update(dt)
end

function game:draw(dt)
  test_room:draw(dt)
end

function game:keypressed(key, scancode, isrepeat)
  test_room:_keypressed(key, scancode, isrepeat)
end

function gameover:enter()
  self.t = 0
end

function gameover:update(dt)
  self.t = self.t + dt
end

function gameover:draw()
  love.graphics.setColor(1,0,0)
  love.graphics.print("you died", 10, 10)
  if self.t > 5 then
    love.graphics.print("you're not very good at this game, are you?", 30, 50)
  end
  if self.t > 10 then
    love.graphics.print("sorry if that was mean",50,500)
  end
end

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(game)
end
