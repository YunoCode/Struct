export type Symbol = {}

return function(Name: string?): Symbol
    local proxy = newproxy(true)

    getmetatable(proxy).__tostring = function()
        return "Symbol ("..(Name or "")..")"
    end

    return proxy
end