local Spring = {}
Spring.__index = Spring

local SpringEq = require(script.Parent.Utils.Spring)

local function udim2ToVector2(value)
    return Vector2.new(value.X.Scale, value.Y.Scale),
           Vector2.new(value.X.Offset, value.Y.Offset)
end

function Spring.new(initialValue: any, speed, damping)
    local initialValue2
    local valueType = typeof(initialValue)

    if typeof(initialValue) == "UDim2" then
        initialValue, initialValue2 = udim2ToVector2(initialValue)
    end

    local self = {
        Value = initialValue,
        _initialValueType = valueType,
        _spring = SpringEq.new(initialValue),
        _spring2 = SpringEq.new(initialValue2),
    }

    speed = speed or 1
    damping = damping or 1

    self._spring.d = damping
    self._spring.s = speed

    if self._spring2 then
        self._spring2.d = damping
        self._spring2.s = speed
    end

    return setmetatable(self, Spring)
end

function Spring:Set(value)
    if typeof(value) == "UDim2" then
        local v1, v2 = udim2ToVector2(value)

        self._spring.t = v1

        if self._spring2 then
            self._spring2.t = v2
        end
        return
    end

    self._spring.t = value
end

function Spring:Push(value)
    if typeof(value) == "UDim2" then
        local v1, v2 = udim2ToVector2(value)

        self._spring.v = v1

        if self._spring2 then
            self._spring2.v = v2
        end
        return
    end

    self._spring.v = value
end

function Spring:Get()
    if self._initialValueType == "UDim2" then
        self.Value = UDim2.new(self._spring.p.X, self._spring2.p.X, self._spring.p.Y, self._spring2.p.Y)
    else
        self.Value = self._spring.p
    end

    return self.Value
end

return Spring