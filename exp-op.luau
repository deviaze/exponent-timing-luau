local process = require("@lune/process")
local x, e = process.args[1], process.args[2]
x = tonumber(x)
e = tonumber(e)

local t0 = os.clock()
local res = x^e
print(string.format("%.12f", os.clock() - t0))