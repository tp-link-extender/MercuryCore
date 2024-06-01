--
-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and https://code.google.com/p/tweener/ (jstweener javascript version)
--

-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin

local easing = {
	Linear = {},
	Quad = {},
	Cubic = {},
	Quart = {},
	Quint = {},
	Sine = {},
	Exponential = {},
	Circular = {},
	Elastic = {},
	Back = {},
	Bounce = {},
}

local function linear(t, b, c)
	return c * t + b
end

easing.Linear.In = linear
easing.Linear.Out = linear
easing.Linear.InOut = linear
easing.Linear.OutIn = linear

function easing.Quad.In(t, b, c)
	return c * pow(t, 2) + b
end

function easing.Quad.Out(t, b, c)
	return -c * t * (t - 2) + b
end

function easing.Quad.InOut(t, b, c)
	t *= 2
	if t < 1 then
		return c / 2 * pow(t, 2) + b
	end
	return -c / 2 * ((t - 1) * (t - 3) - 1) + b
end

function easing.Quad.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Quad.Out(t * 2, b, c / 2)
	end
	return easing.Quad.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Cubic.In(t, b, c)
	return c * pow(t, 3) + b
end

function easing.Cubic.Out(t, b, c)
	t -= 1
	return c * (pow(t, 3) + 1) + b
end

function easing.Cubic.InOut(t, b, c)
	t *= 2
	if t < 1 then
		return c / 2 * t * t * t + b
	end
	t -= 2
	return c / 2 * (t * t * t + 2) + b
end

function easing.Cubic.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Cubic.Out(t * 2, b, c / 2)
	end
	return easing.Cubic.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Quart.In(t, b, c)
	return c * pow(t, 4) + b
end

function easing.Quart.Out(t, b, c)
	t -= 1
	return -c * (pow(t, 4) - 1) + b
end

function easing.Quart.InOut(t, b, c)
	t *= 2
	if t < 1 then
		return c / 2 * pow(t, 4) + b
	end
	t -= 2
	return -c / 2 * (pow(t, 4) - 2) + b
end

function easing.Quart.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Quart.Out(t * 2, b, c / 2)
	end
	return easing.Quart.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Quint.In(t, b, c)
	return c * pow(t, 5) + b
end

function easing.Quint.Out(t, b, c)
	t -= 1
	return c * (pow(t, 5) + 1) + b
end

function easing.Quint.InOut(t, b, c)
	t *= 2
	if t < 1 then
		return c / 2 * pow(t, 5) + b
	end
	t -= 2
	return c / 2 * (pow(t, 5) + 2) + b
end

function easing.Quint.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Quint.Out(t * 2, b, c / 2)
	end
	return easing.Quint.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Sine.In(t, b, c)
	return -c * cos(t * (pi / 2)) + c + b
end

function easing.Sine.Out(t, b, c)
	return c * sin(t * (pi / 2)) + b
end

function easing.Sine.InOut(t, b, c)
	return -c / 2 * (cos(pi * t) - 1) + b
end

function easing.Sine.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Sine.Out(t * 2, b, c / 2)
	end
	return easing.Sine.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Exponential.In(t, b, c)
	if t == 0 then
		return b
	end
	return c * pow(2, 10 * (t - 1)) + b - c * 0.001
end

function easing.Exponential.Out(t, b, c)
	if t == 1 then
		return b + c
	end
	return c * 1.001 * (-pow(2, -10 * t) + 1) + b
end

function easing.Exponential.InOut(t, b, c)
	if t == 0 then
		return b
	elseif t == 1 then
		return b + c
	end
	t *= 2
	if t < 1 then
		return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
	end
	t -= 1
	return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
end

function easing.Exponential.OutIn(t, b, c)
	if t < 0.5 then
		return t.Exponential.Out(t * 2, b, c / 2)
	end
	return t.Exponential.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Circular.In(t, b, c)
	return (-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

function easing.Circular.Out(t, b, c)
	t -= 1
	return (c * sqrt(1 - pow(t, 2)) + b)
end

function easing.Circular.InOut(t, b, c)
	t *= 2
	if t < 1 then
		return -c / 2 * (sqrt(1 - t * t) - 1) + b
	end
	t -= 2
	return c / 2 * (sqrt(1 - t * t) + 1) + b
end

function easing.Circular.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Circular.Out(t * 2, b, c / 2)
	end
	return easing.Circular.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Elastic.In(t, b, c) --, a, p)
	if t == 0 then
		return b
	elseif t == 1 then
		return b + c
	end

	local p = 0.3
	local s

	s = p / 4

	t -= 1

	return -(c * pow(2, 10 * t) * sin((t * 1 - s) * (2 * pi) / p)) + b
end

function easing.Elastic.Out(t, b, c) --, a, p)
	if t == 0 then
		return b
	elseif t == 1 then
		return b + c
	end

	local p = 0.3
	local s
	s = p / 4

	return c * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) + c + b
end

function easing.Elastic.InOut(t, b, c) --, a, p)
	if t == 0 then
		return b
	end

	t *= 2

	if t == 2 then
		return b + c
	end

	local p = 0.45
	local a = 0
	local s

	if not a or a < abs(c) then
		a = c
		s = p / 4
	else
		s = p / (2 * pi) * asin(c / a)
	end

	t -= 1
	if t < 1 then
		return -0.5 * (a * pow(2, 10 * t) * sin((t - s) * (2 * pi) / p)) + b
	end
	return a * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) * 0.5 + c + b
end

function easing.Elastic.OutIn(t, b, c) --, a, p)
	if t < 0.5 then
		return easing.Elastic.Out(t * 2, b, c / 2)
	end
	return easing.Elastic.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Back.In(t, b, c) --, s)
	local s = 1.70158
	return c * t * t * ((s + 1) * t - s) + b
end

function easing.Back.Out(t, b, c) --, s)
	local s = 1.70158
	t -= 1
	return c * (t * t * ((s + 1) * t + s) + 1) + b
end

function easing.Back.InOut(t, b, c) --, s)
	local s = 2.5949095
	t *= 2
	if t < 1 then
		return c / 2 * (t * t * ((s + 1) * t - s)) + b
	end
	t -= 2
	return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
end

function easing.Back.OutIn(t, b, c) --, s)
	if t < 0.5 then
		return easing.Back.Out(t * 2, b, c / 2)
	end
	return easing.Back.In((t * 2) - 1, b + c / 2, c / 2)
end

function easing.Bounce.Out(t, b, c)
	if t < 1 / 2.75 then
		return c * (7.5625 * t * t) + b
	elseif t < 2 / 2.75 then
		t -= 1.5 / 2.75
		return c * (7.5625 * t * t + 0.75) + b
	elseif t < 2.5 / 2.75 then
		t -= 2.25 / 2.75
		return c * (7.5625 * t * t + 0.9375) + b
	end
	t -= 2.625 / 2.75
	return c * (7.5625 * t * t + 0.984375) + b
end

function easing.Bounce.In(t, b, c)
	return c - easing.Bounce.Out(1 - t, 0, c) + b
end

function easing.Bounce.InOut(t, b, c)
	if t < 0.5 then
		return easing.Bounce.In(t * 2, 0, c) * 0.5 + b
	end
	return easing.Bounce.Out(t * 2 - 1, 0, c) * 0.5 + c * 0.5 + b
end

function easing.Bounce.OutIn(t, b, c)
	if t < 0.5 then
		return easing.Bounce.Out(t * 2, b, c / 2)
	end
	return easing.Bounce.In((t * 2) - 1, b + c / 2, c / 2)
end

return easing
