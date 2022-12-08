//
//  Vertex.metal
//  MetalShader
//
//  Created by ミズキ on 2022/12/01.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(unsigned int vid [[ vertex_id ]]) {
    const float4x4 vertices = float4x4(float4( -1.0, -1.0, 0.0, 1.0 ),
                                           float4(  1.0, -1.0, 0.0, 1.0 ),
                                           float4( -1.0,  1.0, 0.0, 1.0 ),
                                           float4(  1.0,  1.0, 0.0, 1.0 ));
    return vertices[vid];
}
