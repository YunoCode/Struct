local Do = {}
Do.__index = Do

function Do.new()
    return setmetatable({
        _storage = {}
    }, Do)
end

function Do:Insert(item)
    return table.insert(self._storage, item)
end

function Do:Find(item)
    return table.find(self._storage, item)
end

function Do:_getAll()
    return self._storage
end

return function(fn)
    local new = Do.new()
    fn(new)
    local all = new:_getAll()
    return all
end

--[[

    Do(function(self)
        self:insert("aui9fhu")
    end)

]]