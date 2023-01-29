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

    return Redo ( SmoothButton (props) ) {
        Name = "Urmom",
        Size = sizeSpring,

        -- [Struct.Symbols.Events] = props[Struct.Symbols.Events] -- Helper.Overwrite (props[Struct.Symbols.Events]) {
            -- MouseEnter = function()
            --     sizeSpring:Set(Helper.MultUDim2(propSize, 1.1))
            -- end,

            -- MouseLeave = function()
            --     sizeSpring:Set(propSize)
            -- end,
        -- } 
    }
end



