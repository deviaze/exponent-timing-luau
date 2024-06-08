local process = require("@lune/process")
local task = require("@lune/task")
local fncall = "./exp-fncall.luau"
local pow = "./exp-pow.luau"
local op = "./exp-op.luau"

local f = 0
local p = 0
local o = 0

local iters = 1000
if iters > 120 then
	print(`might take a while: {iters} iterations`)
	task.wait(1)
end
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

print(`\nwith {iters} iterations of running the files in arbitrary order:`)
print(`functioncall: {ftime(f/iters)} seconds`)
print(`math.pow: {ftime(p/iters)} seconds`)
print(`x^e: {ftime(o/iters)} seconds`)
print(`this test took {ftime(os.clock() - start_t)} seconds to run`)

local function randomNumberUnpack(n: number, m: number?): ...number
	local rv = table.create(3)
	local m = m or 127
	for i = 1, n do
		rv[i] = math.random(1, m)
	end
	return table.unpack(rv)
end
local function nf(n)
	return string.format("%.10f", n)
end

local function regularLoopIters(iters)
	local i = 0
	local first_time = 0
	local second_time = 0
	while i < iters do
		local x, y, z = randomNumberUnpack(3)
		local e, f, g = randomNumberUnpack(3, 6)
		local t0 = os.clock()
		local s = math.pow(x, e)
		local t1 = os.clock()
		local u = (function() -- z^g instead avoid cache of x^e by luau optimizations?
			local res = z
			for i = 1, e do
				res *= g
			end
			return res
		end)()
		local t2 = os.clock()
		first_time += t1 - t0
		second_time += t2 - t1
		i += 1
	end
	local t2 = os.clock()
	print("\nregular looping in the same file:")
	print(`with {iters} iterations:`)
	print(`fncall: {nf(first_time / iters)}`)
	print(`pow: {nf(second_time / iters)}`)
end
regularLoopIters(iters)
regularLoopIters(23000)
