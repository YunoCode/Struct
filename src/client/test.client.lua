local Struct = require(script.Parent.Struct)

local New = Struct.New
local Symbols = Struct.Symbols

local HueButton = require(script.Parent.Components.HueButton)

New "ScreenGui" {
    Parent = Symbols.PlayerGui,
    [Symbols.Children] = {
        New "TextLabel" {
            Size = UDim2.new(0, 200, 0, 100),
            Text = "Hello World",
        },

        New (HueButton) {
            Text = "MOMMY MILKY"
        }
    }
}