-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here


--
--
local backlayer = display.newGroup()
local player = require("player").new()

local back = display.newImage( "Background.png" )
back:translate( 320/2, 500/2 )
back.width = 110*2 + player._w + 11
back.height = 150*2 + player._h + 11

backlayer:insert(back)

local function update(...)
    player:update(...)
end

Runtime:addEventListener("enterFrame", update)