local table_new = require("table.new") 
local bit = require("bit")
local band, bxor, rshift, lshift = bit.band, bit.bxor, bit.rshift, bit.lshift

local GridSize = 1024
local FullSize = GridSize * GridSize * GridSize
local VoxelGrid = table_new(FullSize,0)


local function DeterministicRandom(x, y, z, seed, min, max)
    local h = bxor(x * 73856093, y * 19349663, z * 83492791, seed * 100000007)

    h = bxor(h, rshift(h, 16))
    h = h * 0x45d9f3b
    h = bxor(h, rshift(h, 16))
    h = h * 0x45d9f3b
    h = bxor(h, rshift(h, 16))

    local range = max - min + 1
    local u_hash = band(h, 0x7fffffff) 
    return min + (u_hash % range)
end

local t = os.clock()

local ctr = 1

for X = 1, GridSize do
  for Z = 1, GridSize do
    for Y = 1, GridSize do
      VoxelGrid[ctr] =  DeterministicRandom(X,Y,Z,1,-999,999)
      ctr = ctr + 1
    end
  end
end

print((os.clock()-t)*1000)