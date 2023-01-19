local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Symbol = require(script.Parent.Utils.Symbol)
local Types = require(script.Parent.Types)
local Signal = require(script.Parent.Utils.Signal)

type State = Types.State

local Update = {
    Type = Symbol("Update"),
    States = {},
    CurrentlyInvoked = nil
}
Update.__index = Update
setmetatable(Update, {__call = function(self, ...)
    return Update.new(...)
end})

type Update = {}

local function capture()
    local captured = {}

    for i, v in Update.States do
        captured[#captured+1] = i
    end

    Update.States = {}

    return captured
end

function Update.new(callback): Update
    local self = {
        _type = Update.Type,
        _callback = callback,
        _stateConnections = {},
        _states = {},
        OnInvoked = Signal.new()
    }

    setmetatable(self, Update)

    Update.CurrentlyInvoked = self
    self._callback()
    Update.CurrentlyInvoked = nil
    local captured = self:_getStates()

    return self
end

function Update:Invoke()
    local ret = self._callback()
    self.OnInvoked:Fire(ret)
    return ret
end

function Update:_getStates()
    local captured
    task.defer(function()
        if not captured then
            error("cannot yield")
        end
    end)
    captured = self:_capture()
    self._states = {}

    for i, v in self._stateConnections do
        if not table.find(captured, v) then
            v:Disconnect()
            table.remove(self._stateConnections, i)
        end
    end

    for i, v in captured do
        table.insert(self._stateConnections, v.OnChanged:Connect(function()
            Update.CurrentlyInvoked = self
            local res = self._callback()
            Update.CurrentlyInvoked = nil
            task.spawn(function()
                self:_getStates()
            end)
            self.OnInvoked:Fire(res)
        end))
    end

    return captured
end

function Update:_capture()
    local captured = {}

    for i, v in self._states do
        captured[#captured+1] = i
    end

    self._states = {}

    return captured
end

function Update.registerState(state)
    local currentlyInvoked = Update.CurrentlyInvoked
    if not currentlyInvoked then return end
    currentlyInvoked._states[state] = true
    --table.insert(Update.States, state)
end

return Update