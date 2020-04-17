Room = require("room")
Sprite = require("sprite")

function love.load()
  local slime = love.graphics.newImage("Slime.png")
  local slime_sprite = Sprite:new()
  test_room = Room:new()
  slime_sprite:set_sprite(slime)
  test_room:insert_sprite(slime_sprite)
  slime_sprite.update = function(self, dt) self.x = self.x + 80*dt self.scalex = self.scalex + dt end
end


function love.update(dt)
  test_room:update(dt)
end

function love.draw(dt)
  test_room:draw(dt)
end
