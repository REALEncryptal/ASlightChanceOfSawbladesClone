-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
function tick()
    return system.getTimer()
end

--
--
local vector2 = require("vector2")
local projectileClass = require("projectile")
local playerClass = require("player")

-- layer
local backlayer = display.newGroup()

--vars
local _x = 320/2
local _y = 500/2

local projectiles = {}
local player = nil

local function update(...)
    if player then
        player:update(...)
    end

    for i, proj in ipairs(projectiles) do
        if proj:update(...) == true then
            table.remove(projectiles, i)
        end
    end
end

--create function to spawn a projectile
local function spawnProjectile()
    local angle = math.random(30, 65)
    if math.random(0,1) == 0 then
        angle = math.random(110, 150)
    end

    local position = vector2.new(math.random(80,200), 110)
    local proj = projectileClass.new(position, angle, player)

    table.insert(projectiles, proj)
end

function clamp(num, min, max)
    return math.min(math.max(num, min), max)
end

function newGame()
    player = playerClass.new()
    local score = 0
    local scoreText = display.newText( "Score: " .. score, 100, 10, native.systemFont, 25)
    local projectilesPerTime = 1
    local startTime = tick()

    local back = display.newImage( "Background.png" )
    back:translate( 320/2, 500/2 )
    back.width = 110*2 + player._w + 11
    back.height = 150*2 + player._h + 11
    backlayer:insert(back)
    

    --spawn projectiles
    timer.performWithDelay(1500, function()
        --the amount of projectiles to spawn is based off of score and time elapsed
        -- the most will be 3 projectiles per second

        local elapsed = math.floor((tick() - startTime) /1000)

        local scale = math.random(
            0, 
            clamp(
                elapsed,
                0, 
                120
            )
        )

        local toSpawn = 1

        if scale >= 90 then
            toSpawn = 3
        elseif scale >= 20 then
            toSpawn = 2
        end
        
        for i = 1, toSpawn do
            spawnProjectile()
        end
    end, 0)

    player.onScore = function(count)
        score = score + count
        scoreText.text = "Score: " .. score
    end
end


Runtime:addEventListener("enterFrame", update)


newGame()