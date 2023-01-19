local Struct = require(script.Parent.Parent.Struct)

local New = Struct.New

return function (props)
    return New "TextButton" {
        Name = "SmoothButton",
        Size = props.Size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = props.Text,
        Position = props.Position,
        Font = Enum.Font.Gotham,
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,

        [Struct.Symbols.Children] = {
            New "UICorner" {
                CornerRadius = UDim.new(0, props.Bevel)
            }
        }
    }
end

