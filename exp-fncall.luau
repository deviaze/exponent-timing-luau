local process = require("@lune/process")
local x, e = process.args[1], process.args[2]
x = tonumber(x)
e = tonumber(e)

local t0 = os.clock();
local res = (function()
	local r = x
	for i = 1, e do
		r *= x
	end
	return r
end)()
print(string.format("%.12f", os.clock() - t0))