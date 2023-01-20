local Helper = {}

function Helper.MultUDim2(udim2, multiply)
    return UDim2.new(
        udim2.X.Scale * multiply,
        udim2.X.Offset * multiply,
        udim2.Y.Scale * multiply,
        udim2.Y.Offset * multiply
    )
end

function Helper.OffsetToScale(udim2)
    local viewportSize = workspace.CurrentCamera.ViewportSize

    return UDim2.new(
        udim2.X.Scale + (udim2.X.Offset/viewportSize.X),
        0,
        udim2.Y.Scale + (udim2.Y.Offset/viewportSize.Y),
        0
    )
end

function Helper.Overwrite(original)
    return function (with)
        local new = {}
        for i, v in original do
            if with[i] then
                new[i] = with[i]
            else
                new[i] = v
            end
        end
        return new 
    end
end

return Helper