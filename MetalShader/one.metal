//
//  MetalOne.metal
//  MetalShader
//
//  Created by ミズキ on 2022/12/01.
//

#include <metal_stdlib>
#include "Common.h"
using namespace metal;

fragment float4 oneMetal(float4 pixPos [[position]],
                              constant float2& res [[buffer(0)]],
                              constant float& time[[buffer(1)]]) {
    float2 uv = (2.0 * pixPos.xy - res) / min(res.x, res.y);
    uv.y *= -1.0;

    float l = length(uv);
    float ring = abs(step(0.8, l) - step(1.0, l));
    float phase = atan2(uv.y, uv.x) + M_PI_F;
    float h = phase / (2.0 * M_PI_F);
    float s = saturate(l);
    float3 rgb = hsv2rgb(fract(h + 0.2 * time), s, 1.0);

    return float4(rgb, 1.0) * ring;
}
