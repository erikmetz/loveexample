-- Class that draws a static background that takes in a filepath to the constructor.
Background = {}
Background.__index = Background

function Background:new(bg_file)
  local bg = {}
  setmetatable(bg, Background)
  bg.bg_file = bg_file
  return bg
end

function Background:draw_full_background()
  local window_width = love.graphics.getWidth()
  local window_height = love.graphics.getHeight()
  local background = love.graphics.newImage('background.png')
  for i = 0, window_width, 40 do
    for j = 0, window_height, 40 do
      love.graphics.draw(background, i, j)
    end
  end

end

return Background
