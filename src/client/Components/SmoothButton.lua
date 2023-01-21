local Struct = require(script.Parent.Parent.Struct)

local Helper = Struct.Helper

local New = Struct.New

return function (props)
    return New "TextButton" ({
        Name = "SmoothButton",
        Size = props.Size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Text = props.Text,
        Position = props.Position,
        Font = Enum.Font.Gotham,
        TextSize = 20,
        BackgroundColor3 = props.BackgroundColor3,
        AutoButtonColor = false,
        TextColor3 = props.TextColor3,

        [Struct.Symbols.Children] = {
            New "UICorner" {
                CornerRadius = UDim.new(0, props.Bevel)
            }
        }
    })
end

