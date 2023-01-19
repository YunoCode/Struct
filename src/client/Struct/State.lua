local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Symbol = require(script.Parent.Utils.Symbol)
local Update = require(script.Parent.Update)
local Signal = require(script.Parent.Utils.Signal)

local State = {
    Type = Symbol("State"),
}
State.__index = State

function State.new(initial)
    local self = {
        _state = if initial == nil then {} else initial,
        OnChanged = Signal.new(),
        _type = State.Type,
        _updates = {},
    }

    setmetatable(self, State)

    return self
end

function State:Get(notReturnSelf)

    if notReturnSelf ~= true then
        Update.registerState(self)
    end

    return self._state
end

function State:Set(state)
    self._state = state
    self.OnChanged:Fire(self._state)
end

return State