--[[The visual novel based part of the game]]--
-- Makes itself an object --
local vn = {}

-- Calls opbjects --
local reader = require("game.text_txt.reader")

-- Initializer function --
function vn.initialize(screenObj, audioObj, inputObj, loaderObj, scene)
  -- Loads main objects --
  screen = screenObj
  audio = audioObj
  input = inputObj
  loader = loaderObj
  alpha = 0       -- Alpha value
  press = 0
  pressed = 0  -- Keypress limit
  fadeInTime = 0  -- Fade in time

  -- Initializes script reader --

  reader.initialize(scene)
end

-- VN's draw function --
function vn.draw()

  -- Draws characters --
  -- Parse chars --
  pos = string.find(reader.scriptImg[scene], ",", 1, true)
  if not(string.sub(reader.scriptImg[scene], 1, pos-1) == "nil") then
    char1 = love.graphics.newImage("game/text_txt/chars/" .. string.sub(reader.scriptImg[scene], 1, pos-1).. ".png")
  end
  if not(string.sub(reader.scriptImg[scene], pos+1) == "nil") then
    char2 = love.graphics.newImage("game/text_txt/chars/" .. string.sub(reader.scriptImg[scene], pos+1).. ".png")
  end

  -- Draw Chars --
  if not(char1 == nil) then
    love.graphics.draw(char1, 800/2/2/2 , 600/2/2, 0, 3)
  end
  if not(char2 == nil) then
    love.graphics.draw(char2, 800/2/2*2+800/2/2/2 , 600/2/2, 0, 3)
  end

  -- Draw Rectangles --
  love.graphics.rectangle("fill", 800*0.05, 600/2/2*3-30, 800-600*0.15, 600*0.25-600*0.25*0.1)

  -- Draws vn text --
  if not (reader.scriptNames[scene] == "nil") then
    love.graphics.print({{255, 0, 0,alpha},reader.scriptNames[scene]}, 800*0.07, 600/2/2*3-10, 0, 1.2)
  end
  love.graphics.printf({{0, 0, 0,alpha}, reader.scriptText[scene]}, 800*0.3, 600/2/2*3-10, 250, "center", 0, 1.2)
  vn.fadeIn()

  -- Draws text space and prints text asking for input --
  love.graphics.print({{0, 255, 0, 1},"<Press Return>"}, 800-175, 600-70, 0, 1.2)
end

-- Fades text --
function vn.fadeIn()
  if love.timer.getTime() <= fadeInTime+0.35 then
    alpha = alpha+0.05
  else
    fadeInTime = love.timer.getTime()
  end
end

-- VN's update function --
function vn.update()

  if love.timer.getTime() >= press+0.3 and pressed == 1 then
    pressed = 0;
  end

  -- Action to go to next scene with delay --
  if love.keyboard.isDown("return") and pressed==0 then
    -- Ends game when script ends --

    if (scene == #reader.scriptImg) then
      loader.changeGame("pong")
    elseif pressed==0 then
      reader.nextScene()    -- Goes to next scene
      alpha = 0             -- Resets alpha value
    end
    --return was pressed,so it is unable to be pressed again--
    pressed=1
    press = love.timer.getTime()
  end
end

-- Returns itself --
return vn
