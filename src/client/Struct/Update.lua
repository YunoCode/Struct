local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Symbol = require(script.Parent.Utils.Symbol)
local Types = require(script.Parent.Types)
local Signal = require(script.Parent.Utils.Signal)

type State = Types.State

local Update = {
    Type = Symbol("Update"),
    Invokables = {},
    CurrentlyInvoked = nil
}
Update.__index = Update

type Update = {}

function Update.new(callback): Update
    local self = setmetatable({
        _type = Update.Type,
        _callback = callback,
        _invokableConnections = {},
        _invokables = {},
        OnInvoked = Signal.new()
    }, Update)

    Update.CurrentlyInvoked = self
    self._callback()
    Update.CurrentlyInvoked = nil
    task.spawn(function()
        self:_getStates()
    end)

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
    self._invokables = {}

    for i, v in self._invokableConnections do
        if not table.find(captured, v) then
            v:Disconnect()
            table.remove(self._invokableConnections, i)
        end
    end

    for i, v in captured do
        if v.OnChanged then
            table.insert(self._invokableConnections, v.OnChanged:Connect(function()
                Update.CurrentlyInvoked = self
                local res = self._callback()
                Update.CurrentlyInvoked = nil
                task.spawn(function()
                    self:_getStates()
                end)
                self.OnInvoked:Fire(res)
            end))
        elseif v then
            local c; c = RunService.Heartbeat:Connect(function(deltaTime)
                Update.CurrentlyInvoked = self
                local res = self._callback()
                Update.CurrentlyInvoked = nil
                task.spawn(function()
                    self:_getStates()
                end)
                self.OnInvoked:Fire(res)
            end)
            table.insert(self._invokableConnections, c)
        end
    end

    return captured
end

function Update:_capture()
    local captured = {}

    for i, v in self._invokables do
        captured[#captured+1] = i
    end

    self._invokables = {}

    return captured
end

function Update.registerState(invokable)
    local currentlyInvoked = Update.CurrentlyInvoked
    if not currentlyInvoked then return end
    currentlyInvoked._invokables[invokable] = true
    --table.insert(Update.States, state)
end

return Update