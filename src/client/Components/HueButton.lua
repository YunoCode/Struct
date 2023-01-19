local Struct = require(script.Parent.Parent.Struct)

return function (props)
    return Struct.New "Frame" {
        Name = props.Text,
        Size = UDim2.new(0, 100, 0, 200)
    }
end

