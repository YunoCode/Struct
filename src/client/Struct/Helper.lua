local Helper = {}

local function deepCopy(t)
    local new = {}

    for i, v in t do
        if type(v) == "table" then
            new[i] = deepCopy(v)
        else
            new[i] = v
        end
    end

    return new
end

local function shallowCopy(t)
    local new = {}

    for i, v in t do
        new[i] = v
    end

    return new
end

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
        local new = shallowCopy(original)

        for i, v in with do
            new[i] = v
        end

        return new
    end
end

return Helper