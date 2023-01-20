local StarterPack = game:GetService("StarterPack")
local Struct = require(script.Parent.Struct)

local New = Struct.New
local Symbols = Struct.Symbols
local Update = Struct.Update
local State = Struct.State
local Spring = Struct.Spring

local SmoothButtonExpand = require(script.Parent.Components.SmoothButtonExpand)

local Theme = State(Color3.fromRGB(255, 255, 255))
local themeSpring = Spring()

New "ScreenGui" {

    Parent = Symbols.PlayerGui,
    [Symbols.Children] = {
        SmoothButtonExpand {
            Text = Update(function()
                return tostring(Theme:Get())
            end),
            Size = UDim2.new(0, 200, 0, 50),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Bevel = 6,
            Color = Update(function()
                
            end),

            [Symbols.Events] = {
                Activated = function()
                    Theme:Set(Theme:Get() == Color3.new(1, 1, 1) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
                end
            }
        }
    }
}


