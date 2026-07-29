local GridSize = 256
local FullSize = GridSize * GridSize * GridSize
local VoxelGrid = table.create(FullSize, 0)

local function DeterministicRandom(x, y, z, seed, min, max)
    local h = (x * 73856093) ~ (y * 19349663) ~ (z * 83492791) ~ (seed * 100000007)

    h = h ~ (h >> 16)
    h = (h * 0x45d9f3b) & 0xFFFFFFFF
    h = h ~ (h >> 16)
    h = (h * 0x45d9f3b) & 0xFFFFFFFF
    h = h ~ (h >> 16)

    local range = max - min + 1
    local u_hash = h & 0x7fffffff
    return min + (u_hash % range)
end

local t = os.clock()

local ctr = 1

for X = 1, GridSize do
  for Z = 1, GridSize do
    for Y = 1, GridSize do
      VoxelGrid[ctr] = DeterministicRandom(X, Y, Z, 1, -999, 999)
      ctr = ctr + 1
    end
  end
end

print((os.clock() - t) * 1000)