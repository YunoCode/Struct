local RunService = game:GetService("RunService")
---------------------------------
--> Made by: ProxyBuild			-
--> Date: 25/9/2021				-
---------------------------------
local Spring = {}

local function GetTime()
	return os.clock()
end

--- Creates a new spring
-- @param initial A number or Vector3 (anything with * number and addition/subtraction defined)
function Spring.new(initial)
	local target = initial or 0

	return setmetatable({
		_time0 = GetTime();
		_position0 = target;
		_velocity0 = 0*target;
		_target = target;
		_damper = 0.6;
		_speed = 15;
	}, Spring)
end

--- Impulse the spring with a change in Velocity
-- @param Velocity The Velocity to impulse with
function Spring:Impulse(Velocity)
	self.Velocity = self.Velocity + Velocity
end

--- Skip forwards in now
-- @param delta now to skip forwards
function Spring:TimeSkip(delta)
	local now = GetTime()
	local position, Velocity = self:_positionVelocity(now+delta)
	self._position0 = position
	self._velocity0 = Velocity
	self._time0 = now
end

function Spring:__index(index)
	if Spring[index] then
		return Spring[index]
	elseif index == "Value" or index == "Position" or index == "p" then
		local position, _ = self:_positionVelocity(GetTime())
		return position
	elseif index == "Velocity" or index == "v" then
		local _, Velocity = self:_positionVelocity(GetTime())
		return Velocity
	elseif index == "Target" or index == "t" then
		return self._target
	elseif index == "Damper" or index == "d" then
		return self._damper
	elseif index == "Speed" or index == "s" then
		return self._speed
	else
		error(("%q is not a valid member of Spring"):format(tostring(index)), 2)
	end
end

function Spring:__newindex(index, value)
	local now = GetTime()

	if index == "Value" or index == "Position" or index == "p" then
		local _, Velocity = self:_positionVelocity(now)
		self._position0 = value
		self._velocity0 = Velocity
	elseif index == "Velocity" or index == "v" then
		local position, _ = self:_positionVelocity(now)
		self._position0 = position
		self._velocity0 = value
	elseif index == "Target" or index == "t" then
		local position, Velocity = self:_positionVelocity(now)
		self._position0 = position
		self._velocity0 = Velocity
		self._target = value
	elseif index == "Damper" or index == "d" then
		local position, Velocity = self:_positionVelocity(now)
		self._position0 = position
		self._velocity0 = Velocity
		self._damper = math.clamp(value, 0, 1)
	elseif index == "Speed" or index == "s" then
		local position, Velocity = self:_positionVelocity(now)
		self._position0 = position
		self._velocity0 = Velocity
		self._speed = value < 0 and 0 or value
	else
		error(("%q is not a valid member of Spring"):format(tostring(index)), 2)
	end

	self._time0 = now
end

local cos, sin = math.cos, math.sin
local sqrt, exp = math.sqrt, math.exp

function Spring:_positionVelocity(now)
	local p0 = self._position0
	local v0 = self._velocity0
	local p1 = self._target
	local d = self._damper
	local s = self._speed

	local t = s*(now - self._time0)
	local d2 = d*d

	local h, si, co
	if d2 < 1 then
		h = sqrt(1 - d2)
		local ep = exp(-d*t)/h
		co, si = ep*cos(h*t), ep*sin(h*t)
	elseif d2 == 1 then
		h = 1
		local ep = exp(-d*t)/h
		co, si = ep, ep*t
	else
		h = sqrt(d2 - 1)
		local u = exp((-d + h)*t)/(2*h)
		local v = exp((-d - h)*t)/(2*h)
		co, si = u + v, u - v
	end

	local a0 = h*co + d*si
	local a1 = 1 - (h*co + d*si)
	local a2 = si/s

	local b0 = -s*si
	local b1 = s*si
	local b2 = h*co - d*si

	return a0*p0 + a1*p1 + a2*v0, b0*p0 + b1*p1 + b2*v0
end

function Spring:Destroy()
	self = nil
end

return Spring