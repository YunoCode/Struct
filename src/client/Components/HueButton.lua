local Struct = require(script.Parent.Parent.Struct)

local New = Struct.New

return function (props)
    return New "Frame" {
        Name = props.Text,
        Size = UDim2.new(0, 100, 0, 200)
    }
end

