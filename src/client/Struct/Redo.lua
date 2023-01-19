local New = require(script.Parent.New)

local function redo(gui)
    return function (rewriteProperties)
        New.AssignProperties(gui, rewriteProperties)

        return gui
    end
end


return redo