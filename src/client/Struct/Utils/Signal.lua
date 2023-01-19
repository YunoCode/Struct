--[[
	Signal module made by proxy.
]]

local Signal = {Signals = {}}
Signal.__index = Signal

export type Signal = {}

setmetatable(Signal, {
	__index = function(self, Name)
		return Signal.new(Name)
	end,
})

function Signal.new(Name): Signal
    Name = Name or #Signal.Signals+1
	if Signal.Signals[Name] then return Signal.Signals[Name] end

	Signal.Signals[Name] = setmetatable({
		_Connections = {},
		Name = Name
	}, Signal)

	return Signal.Signals[Name]
end

function Signal:Connect(f)
	assert = type(f) ~= 'function' and error "Tried to connect with invalid value Type. Requires function"
	table.insert(self._Connections, f)
	return {
		Disconnect = function()
			table.remove(self._Connections, table.find(self._Connections, f))
		end
	}
end

function Signal:GetConnections()
	return self._Connections
end

function Signal:Fire(...)
	local args = {...}
	for i = #self._Connections, 1, -1 do
		local v = self._Connections[i]
		if type(v) == 'function' then
			task.spawn(v, unpack(args))
		end
	end
end

function Signal:FireYield(...)
	local args = {...}
	for i = #self._Connections, 1, -1 do
		local v = self._Connections[i]
		if type(v) == 'function' then
			v(unpack(args))
		end
	end
end

function Signal:Wait()
	local w = coroutine.running()
	local cn
	local args

	cn = self:Connect(function(...)
		cn:Disconnect()
		args = {...}
		task.spawn(w, ...)
	end)

	coroutine.yield()

	return unpack(args)
end

function Signal:Destroy()
	self._Connections = nil
	table.clear(self)
	Signal.Signals[self.Name] = nil
end

return Signal
