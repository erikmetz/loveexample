
Room = require("room")
Sprite = require("sprite")
Collision_Sprite = require("collision_sprite")
Slime_Char = require("slime_char")

function love.load()
  local slime = love.graphics.newImage("Slime.png")
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

  test_room = Room:new()

  for i = 1, 100 do
    local slime_instance = Slime_sprite:new()
    slime_instance:init(i)
    test_room:insert_collision_sprite(slime_instance)
  end

  local slime_char_instance = Slime_Char:new()
  slime_char_instance.x = 550
  slime_char_instance.y = 550
  test_room:insert_collision_sprite(slime_char_instance)


end


function love.update(dt)
  test_room:update(dt)
end

function love.draw(dt)
  test_room:draw(dt)
end
