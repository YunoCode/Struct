local New = {}

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Symbols = require(script.Parent.Symbols)
local Update = require(script.Parent.Update)
local State = require(script.Parent.State)
local Types = require(script.Parent.Types)
local Spring = require(script.Parent.Spring)

local function throwErr(s)
    error("Struct.New: "..s, 4)
end

type State = Types.State
type Update = Types.Update
type Symbol = Types.Symbol

local function trySetProperty(instance, i, v)
    local isPropertyExist = pcall(function()
        return instance[i]
    end)

    if not isPropertyExist then
        throwErr(("property %s is not a valid property in %s"):format(i, instance.ClassName))
    end

    local isAssignedValueValid = pcall(function()
        instance[i] = v
    end)

    if not isAssignedValueValid then
        throwErr(("value type of %s not compatible with property %s"):format(typeof(v), i))
    end
end

type Properties = { [string | Symbol]: any | State | Update | {}, }

function New.new(ClassName: string | () -> (Instance))
    local scs, instance = pcall(Instance.new, ClassName)
    local component

    if not scs then
        if type(ClassName) == "function" then
            component = ClassName
        else
            throwErr("instance Name is not valid "..ClassName)
        end
    end

    return function(Properties: Properties): Instance
        if scs then
            New.AssignProperties(instance, Properties)
            return instance
        elseif component then
            return component(Properties)
        else
            throwErr("unknown fatal error")
        end
    end
end

function New.AssignProperties(instance: Instance, Properties)
    print(Properties)
    for i, v in Properties do
        if type(i) == "string" then
            if i == "Parent" and v == Symbols.PlayerGui then
                instance[i] = PlayerGui
            elseif type(v) == "table" then
                local connection
                if v._type == State.type then
                    trySetProperty(instance, i, v:Get())
                    connection = v.OnChanged:Connect(function(res)
                        instance[i] = res
                    end)
                elseif v._type == Update.Type then
                    --print(v.)
                    trySetProperty(instance, i, v:Invoke())
                    connection = v.OnInvoked:Connect(function(res)
                        trySetProperty(instance, i, res)
                    end)
                    
                elseif v._type == Spring.Type then
                    trySetProperty(instance, i, v:Get())
                    connection = RunService.Heartbeat:Connect(function(deltaTime)
                        local res = v:Get()
                        if res ~= instance[i] then
                            instance[i] = v:Get()
                        end
                    end)
                end

                local connection2; connection2 = instance.Destroying:Connect(function()
                    connection2:Disconnect()
                    connection:Disconnect()
                end)
            else
                trySetProperty(instance, i, v)
            end
        elseif i == Symbols.Children then
            for index, new in v do
                if type(index) ~= "number" then
                    -- assigned property
                    New.AssignProperties(instance[index], new)
                else
                    new.Parent = instance
                end
            end
        elseif i == Symbols.Events then
            for eventName, eventFn in v do
                if instance[eventName] then
                    instance[eventName]:Connect(eventFn)
                else
                    throwErr(("event %s is not a valid event Name"):format(eventName)) 
                end
            end
        else
            throwErr("unknown property Type")
        end
    end
end

return New