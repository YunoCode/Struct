local Spring = {}
Spring.__index = Spring

local SpringEq = require(script.Parent.Utils.SpringEq)
local Symbol = require(script.Parent.Utils.Symbol)
local Update = require(script.Parent.Update)

local ToTable, ToValue = require(script.ToTable), require(script.ToValue)

Spring.Type = Symbol("Spring")

function Spring.new(initialValue: any, speed, damping)
    local ToTableV = {}
    local self = {
        Value = initialValue,
        Type = typeof(initialValue),
        ToTableV = {},
        _spring = SpringEq.new(ToTable(initialValue, ToTableV)),
        _type = Spring.Type
    }

    speed = speed or 1
    damping = damping or 1

    self._spring.d = damping
    self._spring.s = speed

    return setmetatable(self, Spring)
end

function Spring:Set(value)
    self._spring.t = ToTable(value)
end

function Spring:Push(value)
    self._spring.v = ToTable(value)
end

function Spring:Get(notReturnSelf)

    if notReturnSelf ~= true then
        Update.registerState(self)
    end

    return ToValue(self._spring.p, self.Type)
end

return Spring


