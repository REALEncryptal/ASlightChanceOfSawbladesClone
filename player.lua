local player = {}
player.__index = player


local vector2 = require("vector2")
local inputUtil = require("inputUtil")

function clamp(num, min, max)
    return math.min(math.max(num, min), max)
end

function tick()
    return system.getTimer()
end

local _x = 320/2
local _y = 500/2

function player.new()
    local self = setmetatable({}, player)

    -- settings
    self.gravity = vector2.new(0, .8)
    self.speed = 3.4
    self.airSpeed = 1
    self.terminalVelocity = 10
    self.timeUntilLongJump = 100

    self.jumpPower = 8
    self.powerJumpPower = 10
    self.doubleJumpPower = 10

    -- bounds
    self.min_y = _y - 150
    self.max_y = _y + 150

    self.min_x = _x - 110
    self.max_x = _x + 110

    self.size = 10

    --properties
    self.position = vector2.new(160, 50)
    self.velocity = vector2.new()

    self.jumpsLeft = 1
    self.grounded = false
    self.requestJump = false
    self.wishDir = vector2.new()
    self.lastJump = nil
    self.jumpHeld = false
    self.wDown = false

    -- internal
    self._w, self._h = 2*self.size, 2.2*self.size
    self._phys = display.newRect(200, 200, self._w, self._h) 
    self._phys.fill = {1, 0.5, 0}
    self._text = display.newText( "hello", 100, 10, native.systemFont, 25)

    inputUtil.onInputBegan("w", function()
        --self:jump()
    end)

    return self
end

function player:movement()
    -- get wish dir
    self.wishDir = vector2.new()
    if inputUtil.isKeyDown("a") then
        self.wishDir = vector2.new(-1)
    else
        self.wishDir = vector2.new()
    end

    if inputUtil.isKeyDown("d") then
        self.wishDir = vector2.new(self.wishDir.x + 1)
    end
    -- move
    self.velocity = vector2.new(self.wishDir.x * self.speed, self.velocity.y)
end

function player:jump()
    if self.jumpsLeft <= 0 then return end
    self.jumpsLeft = self.jumpsLeft - 1

    if self.grounded then
        self.lastJump = tick()
    end
    
    if not self.grounded then
        self.velocity.y = -self.doubleJumpPower
        return
    end
    self.velocity.y = -self.jumpPower
end

function player:update(dt)
    local wasGrounded = self.grounded
    self.grounded = self.position.y > 398.5
    local wasWDown =self.wDown
    self.wDown = inputUtil.isKeyDown("w")

    -- reset jumps
    if self.grounded then
        self.jumpsLeft = 2
    end

    --detect jumps
    if self.wDown and not wasWDown then
        if self.grounded then
            self.jumpHeld = tick()
            self.velocity.y = -self.jumpPower
        elseif self.jumpsLeft > 1 then
            self.jumpHeld = false
            self.jumpsLeft = self.jumpsLeft - 1
            self.velocity.y = -self.doubleJumpPower
        end
    end

    if not self.grounded and not self.wDown then
        self.jumpHeld = false
    end

    if self.wDown and wasWDown and not self.grounded and self.jumpHeld then
        local timeSince = tick() - self.jumpHeld
        if timeSince > 400 then 
            self.jumpHeld = false
            return
        end
        self.velocity.y = -self.jumpPower
    end

    
    -- do movement
    self:movement()
    -- apply vel
    self.velocity = self.velocity + self.gravity
    self.position = self.position + self.velocity

    self.velocity.y = clamp(self.velocity.y, -self.terminalVelocity, self.terminalVelocity)

    --constrain position and vel
    if self.position.x > self.max_x or self.position.x < self.min_x then
        self.velocity = self.velocity * vector2.new(0,1)
    end

    if self.position.y > self.max_y or self.position.y < self.min_y then
        self.velocity = self.velocity * vector2.new(1, 0)
    end

    self.position = vector2.new(
        clamp(self.position.x, self.min_x, self.max_x),
        clamp(self.position.y, self.min_y, self.max_y)
    )

    -- apply movement to phys
    self._phys.x, self._phys.y = self.position.x, self.position.y

    self._text.text = self.gravity.y
end

return player