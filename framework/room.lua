Room = {objects = {}, sprites = {}}
Room.sprite_canvas = nil


function Room:new(r)
  r = r or {}
  setmetatable(r, self)
  self.__index = self
  return r
end

function Room:update(dt)
  self:special_update(dt)
  for _, obj in pairs(self.objects) do
    obj:update(dt)
  end
  for _, sprite in pairs(self.sprites) do
    sprite:update(dt)
  end
end

function Room:special_update(dt)
end

function Room:draw(dt)
  love.graphics.setColor(1,1,1)
  for _, sprite in pairs(self.sprites) do
    sprite:draw(0,0,dt)
  end
end

function Room:insert_sprite(sprite)
  local p = #(self.sprites) + 1
  self.sprites[p] = sprite
  sprite:set_room(room, p)
end

return Room
