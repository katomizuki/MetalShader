//
//  three.metal
//  MetalShader
//
//  Created by ミズキ on 2022/12/09.
//

#include <metal_stdlib>
#include "Common.h"
using namespace metal;

fragment float4 threeShader(float4 pixPos [[position]],
                            constant float2& res[[buffer(0)]],
                            constant float& time[[buffer(1)]]) {
    float2 pos = (2.0 * pixPos.xy - res) / min(res.x, res.y);
    pos.y *= -0.5;

    float3 c = mix(float3(0.0, 1.0, 1.0), float3(0.0, 0.1, 0.1), pos.y);
    //
    float v = sin((pos.x + time * 0.2) * 5.0) * 0.05 + sin((pos.x * 3.0 + time * 0.1) * 5.0) * 0.05;
    // y座標と比べて大きかったら
    if (pos.y < v) {
            c = mix(c, float3(0.0, 0.5, 0.5), 0.2);
    }
    
    v = sin((pos.x + time * 0.1) * 5.0) * 0.05 + sin((pos.x * 3.0 + time * 0.05) * 5.0) * 0.05;
    // y座標と比べて大きかったら
    if (pos.y < v) {
            c = mix(c, float3(0.0, 0.5, 0.5), 0.2);
    }
    return float4(c, 13.0);
}
