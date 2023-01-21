local Struct = require(script.Parent.Struct)

local New = Struct.New
local Symbols = Struct.Symbols
local Update = Struct.Update
local State = Struct.State
local Spring = Struct.Spring

local SmoothButtonExpand = require(script.Parent.Components.SmoothButtonExpand)

local themeSpring = Spring(Color3.new(1, 1, 1), 50, 1)
local Theme = State(themeSpring:Get())

Theme.OnChanged:Connect(function(c)
    themeSpring:Set(c)
end)

New "ScreenGui" {
    Parent = Symbols.PlayerGui,
    [Symbols.Children] = {
        SmoothButtonExpand {
            Text = Update(function()
                return `current color: {tostring(Theme:Get())}`
            end),
            Size = UDim2.new(0, 200, 0, 50),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = themeSpring,
            TextColor3 = Update(function()
                local color = themeSpring:Get()

                return Color3.new(
                    1 - color.R,
                    1 - color.G,
                    1 - color.B
                )
            end),
            Bevel = 6,

            [Symbols.Events] = {
                Activated = function()
                    Theme:Set(Theme:Get() == Color3.new(1, 1, 1) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1))
                end
            }
        }
    }
}


