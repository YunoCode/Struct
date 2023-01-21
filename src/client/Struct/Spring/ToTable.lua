local function apply(t, ...)
    for i, v in {...} do
        t[i] = v
    end

    return t
end

return function(toConvert: any, existingTable: nil | {}): {}
    local hasTable = existingTable ~= nil
    existingTable = if existingTable then existingTable else {}

    if typeof(toConvert) == "UDim2" then
        return apply(existingTable, toConvert.X.Scale, toConvert.X.Offset, toConvert.Y.Scale, toConvert.Y.Offset)
    elseif typeof(toConvert) == "UDim" then
        return apply(existingTable, toConvert.Scale, toConvert.Offset)
    elseif typeof(toConvert) == "Color3" then
        return apply(existingTable, toConvert.R, toConvert.G, toConvert.B)
    elseif typeof(toConvert) == "ColorSequenceKeypoint" then
        return apply(existingTable, toConvert.Value.R, toConvert.Value.G, toConvert.Value.B, toConvert.Time)
    else
        return toConvert
    end

    if not hasTable then return existingTable end
end