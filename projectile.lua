--[[
a projectile class that takes in a position, starting angle, and, parent (the player)

Player class stuff:

...
local _x = 320/2
local _y = 500/2

...
-- bounds
self.min_y = _y - 150
self.max_y = _y + 150
self.min_x = _x - 110
self.max_x = _x + 110


]]

local vector2 = require("vector2")

local projectile = {}
projectile.__index = projectile

function projectile.new(position, angle, parent)
    local self = setmetatable({}, projectile)

    self.position = position or vector2.new()
    self.angle = angle or 0
    self.parent = parent
    self.charged = false

    self.speed = 3
    self.hitDist = 20
    self.destroyDist = 5

    self._sprite = display.newCircle(position.x, position.y, 14)

    self._alive = true
    return self
end

--destroy function
function projectile:destroy()
    if not self._alive then return end
    self._sprite:removeSelf()
    self._sprite = nil
    self._alive = false
end

-- method to detect when the projectile is out of bounds and reflect it
function projectile:OutOfBounds()
    -- if it touchs the roof coming from the bottom then destroy it
    if self.position.y < self.parent.min_y then
        self:destroy()
        return
    end

    if self.position.x < self.parent.min_x then
        self.position.x = self.parent.min_x
        self.angle = 180 - self.angle
    elseif self.position.x > self.parent.max_x then
        self.position.x = self.parent.max_x
        self.angle = 180 - self.angle
    end

    if self.position.y < self.parent.min_y then
        self.position.y = self.parent.min_y
        self.angle = 360 - self.angle
    elseif self.position.y > self.parent.max_y then
        self.position.y = self.parent.max_y
        self.angle = 360 - self.angle
    end
end

--check if player position is within 40 pixels of the projectile and call player:hit()
function projectile:CheckHit(player)
    local distance = (self.position - player.position):magnitude()

    if distance > self.hitDist then return end

    player:hit()
end

-- check if player x is near projectile and the player is above the projectile
function projectile:CheckIfAbove(player)
    if self.charged then return end
    local distance = math.abs(self.position.x - player.position.x)

    if distance > self.destroyDist then return end

    if player.position.y < self.position.y then
        table.insert(player.chargedProjectiles, self)
        print(#player.chargedProjectiles)
        self.charged = true
        -- change color to green of sprite
        self._sprite.fill = {0, 1, 0}
    end
end


-- update function that moves the projectile in the angle
function projectile:update(dt)
    if not self._alive then return false end
    --update position
    self.position = self.position + vector2.fromAngle(self.angle) * self.speed

    --check for out of bounds
    self:OutOfBounds()

    --check for hit
    self:CheckHit(self.parent)

    --check for above
    self:CheckIfAbove(self.parent)

    if not self._alive then return false end

    --apply to sprite
    self._sprite.x = self.position.x
    self._sprite.y = self.position.y
end

return projectile

