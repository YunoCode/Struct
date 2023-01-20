local RunService = game:GetService("RunService")
local SmoothButton = require(script.Parent.SmoothButton)
local Struct = require(script.Parent.Parent.Struct)

local New = Struct.New
local Redo = Struct.Redo
local Update = Struct.Update
local Helper = Struct.Helper
local Spring = Struct.Spring
local State = Struct.State

return function (props)
    local propSize = Helper.OffsetToScale(props.Size)
    local sizeSpring = Spring(propSize, 50, 1)
    local size = State(sizeSpring:Get())

    RunService.Heartbeat:Connect(function(deltaTime)
        size:Set(sizeSpring:Get())
    end)

    return Redo ( SmoothButton (props) ) {
        Name = "Urmom",
        Size = Update(function()
            return size:Get()
        end),

        [Struct.Symbols.Events] = Helper.Overwrite (props[Struct.Symbols.Events]) {
            MouseEnter = function()
                sizeSpring:Set(Helper.multUDim2(propSize, 1.1))
            end,

            MouseLeave = function()
                sizeSpring:Set(propSize)
            end,
        } 
    }
end



