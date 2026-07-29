import std/[times, bitops]

const
  GridSize = 1024
  FullSize = GridSize * GridSize * GridSize

proc deterministicRandom(x, y, z, seed, minVal, maxVal: int32): int32 {.inline.} =
  var h = uint32(x) * 73856093'u32 xor 
          uint32(y) * 19349663'u32 xor 
          uint32(z) * 83492791'u32 xor 
          uint32(seed) * 100000007'u32

  h = h xor (h shr 16)
  h = h * 0x045d9f3b'u32
  h = h xor (h shr 16)
  h = h * 0x045d9f3b'u32
  h = h xor (h shr 16)

  let range = uint32(maxVal - minVal + 1)
  let uHash = h and 0x7fffffff'u32
  
  return minVal + int32(uHash mod range)

proc main() =
  var voxelGrid = newSeq[int32](FullSize)
  # Cast the buffer address to UncheckedArray to allow direct pointer indexing
  let ptrGrid = cast[ptr UncheckedArray[int32]](addr voxelGrid[0])
  
  let startTime = cpuTime()
  
  var ctr = 0
  for x in 1'i32..GridSize:
    for z in 1'i32..GridSize:
      for y in 1'i32..GridSize:
        ptrGrid[ctr] = deterministicRandom(x, y, z, 1, -999, 999)
        inc ctr

  let elapsedTime = (cpuTime() - startTime) * 1000.0
  echo elapsedTime, " ms"

main()