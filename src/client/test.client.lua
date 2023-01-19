local Struct = require(script.Parent.Struct)

local New = Struct.New
local Symbols = Struct.Symbols

local HueButton = require(script.Parent.Components.SmoothButtonExpand)

New "ScreenGui" {
    Parent = Symbols.PlayerGui,
    [Symbols.Children] = {
        HueButton {
            Text = "Process",
            Size = UDim2.new(0, 200, 0, 50),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Bevel = 6,
        }
    }
}
