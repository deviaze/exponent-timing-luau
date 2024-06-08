local process = require("@lune/process")
local fncall = "./exp-fncall.luau"
local pow = "./exp-pow.luau"
local op = "./exp-op.luau"

local f = 0
local p = 0
local o = 0

local iters = 240
local start_t = os.clock()
for i = 1, iters do
	local x, e = math.random(1, 2300), math.random(1, 10)
	local case = math.random(1, 3)
	if case == 1 then
		local t1 = process.spawn("lune", {"run", fncall, x, e}).stdout
		f += tonumber(t1)
		local t2 = process.spawn("lune", {"run", pow, x, e}).stdout
		p += tonumber(t2)
		local t3 = process.spawn("lune", {"run", op, x, e}).stdout
		o += tonumber(t3)
	elseif case == 2 then
		local t2 = process.spawn("lune", {"run", pow, x, e}).stdout
		p += tonumber(t2)
		local t3 = process.spawn("lune", {"run", op, x, e}).stdout
		o += tonumber(t3)
		local t1 = process.spawn("lune", {"run", fncall, x, e}).stdout
		f += tonumber(t1)
	else
		local t3 = process.spawn("lune", {"run", op, x, e}).stdout
		o += tonumber(t3)
		local t2 = process.spawn("lune", {"run", pow, x, e}).stdout
		p += tonumber(t2)
		local t1 = process.spawn("lune", {"run", fncall, x, e}).stdout
		f += tonumber(t1)
	end
	print(100 * (i / iters) // 1 .. '%')
end
local function ftime(x) return string.format("%.8f", x) end

print(`with {iters} iterations of running the files in arbitrary order:`)
print(`functioncall: {ftime(f/iters)} seconds`)
print(`math.pow: {ftime(p/iters)} seconds`)
print(`x^e: {ftime(o/iters)} seconds`)
print(`this test took {ftime(os.clock() - start_t)} seconds to run`)