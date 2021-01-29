//
//  File.metal
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(device const float* inA,
                       device const float* inB,
                       device float* result,
                       uint index [[thread_position_in_grid]])
{
    // the for-loop is replaced with a collection of threads, each of which
    // calls this function.
    result[index] = inA[index] + inB[index];
}
