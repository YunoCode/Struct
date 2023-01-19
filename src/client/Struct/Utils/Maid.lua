local Maid = {}

export type Maid = {}

function Maid.new(): Maid
	return setmetatable({
		_Tasks = {}
	}, Maid)
end

function Maid:__index(Index)
	if Maid[Index] then
		return Maid[Index]
	else
		return rawget(self._Tasks, Index)
	end
end

function Maid:__newindex(Index, Value)
	if Maid[Index] then
		return warn("'"..Index.."' is locked for class: Maid")
	end
	
	local OldTask = self._Tasks[Index]
	self._Tasks[Index] = OldTask
	
	if OldTask then
		if typeof(OldTask) == 'RBXScriptConnection' then
			OldTask:Disconnect()
		elseif type(OldTask) == 'function' then
			OldTask()
		elseif OldTask.Destroy then
			OldTask:Destroy()
		end
		
		self._Tasks[Index] = nil
	end
	
end

function Maid:GiveTask(Task)
	local ID = #self._Tasks+1
	
	self._Tasks[ID] = Task
	
	if type(Task) == 'table' and not Task.Destroy and not Task.Disconnect then
		warn("Task "..Task.." cannot be disconnected or destroyed")
	end
	
	return Task, ID
end

function Maid:DoCleaning()
	for ID, Connection in pairs(self._Tasks) do
		if typeof(Connection) == 'RBXScriptConnection' then
			Connection:Disconnect()
		elseif type(Connection) == 'function' then
			Connection()
		elseif Connection.Destroy then
			Connection:Destroy()
		elseif Connection.Disconnect then
			Connection:Disconnect()
		end
		
		self._Tasks[ID] = nil
	end
end

Maid.Destroy = Maid.DoCleaning

return Maid
