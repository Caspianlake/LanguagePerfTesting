#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>

#define GRID_SIZE 1024
#define FULL_SIZE ((size_t)GRID_SIZE * GRID_SIZE * GRID_SIZE)

static inline int32_t deterministic_random(int32_t x, int32_t y, int32_t z,
                                            int32_t seed, int32_t min, int32_t max) {
    int32_t h = (int32_t)((uint32_t)x * 73856093u)
              ^ (int32_t)((uint32_t)y * 19349663u)
              ^ (int32_t)((uint32_t)z * 83492791u)
              ^ (int32_t)((uint32_t)seed * 100000007u);

    uint32_t h_u32 = (uint32_t)h;
    h_u32 ^= h_u32 >> 16;
    h_u32 *= 0x045d9f3bu;
    h_u32 ^= h_u32 >> 16;
    h_u32 *= 0x045d9f3bu;
    h_u32 ^= h_u32 >> 16;

    uint32_t range = (uint32_t)(max - min + 1);
    uint32_t u_hash = h_u32 & 0x7fffffffu;
    return min + (int32_t)(u_hash % range);
}

int main(void) {
    int32_t *voxel_grid = malloc(FULL_SIZE * sizeof(int32_t));
    if (!voxel_grid) {
        fprintf(stderr, "allocation failed\n");
        return 1;
    }

    memset(voxel_grid, 0, FULL_SIZE * sizeof(int32_t));

    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    size_t ctr = 0;
    for (int x = 1; x <= GRID_SIZE; x++) {
        for (int z = 1; z <= GRID_SIZE; z++) {
            for (int y = 1; y <= GRID_SIZE; y++) {
                voxel_grid[ctr++] = deterministic_random(x, y, z, 1, -999, 999);
            }
        }
    }

    clock_gettime(CLOCK_MONOTONIC, &t1);
    double elapsed_ms = (t1.tv_sec - t0.tv_sec) * 1000.0
                       + (t1.tv_nsec - t0.tv_nsec) / 1e6;
    printf("%.3fms\n", elapsed_ms);

    free(voxel_grid);
    return 0;
}
