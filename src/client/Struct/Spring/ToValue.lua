return function(toConvert: any, type: nil | {}): {}
    if type == "UDim2" then
        return UDim2.new(toConvert[1], toConvert[2], toConvert[3], toConvert[4])
    elseif type == "UDim" then
		return UDim.new(toConvert[1], toConvert[2])
    elseif type == "Color3" then
        return Color3.new(toConvert[1], toConvert[2], toConvert[2])
    elseif type == "ColorSequenceKeypoint" then
        return ColorSequenceKeypoint.new(Color3.new(toConvert[1], toConvert[2], toConvert[2]), toConvert[4])
    else
        return toConvert
    end
end