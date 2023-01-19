local State = {}
State.__index = State

local Signal = require(script.Parent.Signal)

function State.new(value: any)
    return setmetatable({
        Value = value,
        OnChanged = Signal.new()
    }, State)
end

function State:Set(newValue, secondParam)
    if type(self.Value) == "table" and secondParam then
        self.Value[newValue] = secondParam
    else
        self.Value = newValue
    end
    self.OnChanged:Fire(self.Value)
end

function State:Get()
    return self.Value
end

function State:Destroy()
    self.OnChanged:Destroy()
    table.clear(self)
end

return State.new