Vector2 = {}
Vector2.__index = Vector2

-- Constructor
function Vector2.new(x, y)
    local self = setmetatable({}, Vector2)
    self.x = x or 0
    self.y = y or 0
    return self
end

--vector2.from angle func
function Vector2.fromAngle(angle)
    angle = math.rad(angle)
    return Vector2.new(math.cos(angle), math.sin(angle))
end

-- Addition
function Vector2.__add(a, b)
    return Vector2.new(a.x + b.x, a.y + b.y)
end

-- Subtraction
function Vector2.__sub(a, b)
    return Vector2.new(a.x - b.x, a.y - b.y)
end

-- Multiplication
function Vector2.__mul(a, scalar)
    if type(scalar) ~= "number" then
        return Vector2.new(a.x * scalar.x, a.y * scalar.y)
    end

    return Vector2.new(a.x * scalar, a.y * scalar)
end

-- Division
function Vector2.__div(a, scalar)
    return Vector2.new(a.x / scalar, a.y / scalar)
end

-- Magnitude
function Vector2:magnitude()
    return math.sqrt(self.x^2 + self.y^2)
end

-- Unit vector
function Vector2:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        return self / mag
    else
        return Vector2.new()
    end
end

-- Dot product
function Vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

-- Print
function Vector2:__tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

-- properties


return Vector2