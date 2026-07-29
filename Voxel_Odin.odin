package main

import "core:fmt"
import "core:time"

GRID_SIZE :: 1024
FULL_SIZE :: GRID_SIZE * GRID_SIZE * GRID_SIZE

deterministic_random :: #force_inline proc(x, y, z, seed, min_val, max_val: i32) -> i32 {
	h := u32(x) * 73856093 ~ u32(y) * 19349663 ~ u32(z) * 83492791 ~ u32(seed) * 100000007

	h = h ~ (h >> 16)
	h = h * 0x45d9f3b
	h = h ~ (h >> 16)
	h = h * 0x45d9f3b
	h = h ~ (h >> 16)

	range := u32(max_val - min_val + 1)
	u_hash := h & 0x7fffffff
	return min_val + i32(u_hash % range)
}

main :: proc() {
	voxel_grid := make([]i32, FULL_SIZE)
	defer delete(voxel_grid)

	start_time := time.now()

	ctr := 0
	for x in i32(1) ..= i32(GRID_SIZE) {
		for z in i32(1) ..= i32(GRID_SIZE) {
			for y in i32(1) ..= i32(GRID_SIZE) {
				#no_bounds_check voxel_grid[ctr] = deterministic_random(x, y, z, 1, -999, 999)
				ctr += 1
			}
		}
	}

	elapsed := time.since(start_time)
	fmt.println(time.duration_milliseconds(elapsed), "ms")
}