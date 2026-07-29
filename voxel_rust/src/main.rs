use std::time::Instant;

const GRID_SIZE: usize = 1024;
const FULL_SIZE: usize = GRID_SIZE * GRID_SIZE * GRID_SIZE;

fn deterministic_random(x: i32, y: i32, z: i32, seed: i32, min: i32, max: i32) -> i32 {
    let h = (x.wrapping_mul(73_856_093))
        ^ (y.wrapping_mul(19_349_663))
        ^ (z.wrapping_mul(83_492_791))
        ^ (seed.wrapping_mul(100_000_007));

    let h_u32 = h as u32;
    let mut h_u32 = h_u32 ^ (h_u32 >> 16);
    h_u32 = h_u32.wrapping_mul(0x045d_9f3b);
    h_u32 = h_u32 ^ (h_u32 >> 16);
    h_u32 = h_u32.wrapping_mul(0x045d_9f3b);
    h_u32 = h_u32 ^ (h_u32 >> 16);

    let range = (max - min + 1) as u32;
    let u_hash = h_u32 & 0x7fff_ffff;
    min + (u_hash % range) as i32
}

fn main() {
    let mut voxel_grid = vec![0i32; FULL_SIZE];
    
    let start = Instant::now();

    let mut ctr = 0;
    for x in 1..=GRID_SIZE {
        for z in 1..=GRID_SIZE {
            for y in 1..=GRID_SIZE {
                voxel_grid[ctr] = deterministic_random(x as i32, y as i32, z as i32, 1, -999, 999);
                ctr += 1;
            }
        }
    }

    let elapsed = start.elapsed();
    println!("{:.3}ms", elapsed.as_secs_f64() * 1000.0);
}