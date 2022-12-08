//
//  one+Fragment.metal
//  MetalShader
//
//  Created by ミズキ on 2022/12/08.
//

#include <metal_stdlib>
#include "Common.h"
using namespace metal;


fragment float4 twoMetal(float4 pixPos [[position]],
                             constant float2& res[[buffer(0)]],
                             constant float& time[[buffer(1)]],
                             constant float& volume[[buffer(2)]]) {

    // アスペクト比の調整なのでお決まり。https://qiita.com/doxas/items/f3f8bf868f12851ea143
    // -res ~ res 変換後、小さい方でわる。-1 ~ 1に変換される。
    float2 uv = (2.0 * pixPos.xy - res) / min(res.x, res.y);
    // metalは逆になるのでこれが必要。
    uv.y *= -1.0;

    // 枠を作成後、2倍して(0~2) -1にして -1 ~ 1に変換
//    float2 smallUV = 2.0 * fract(uv * 3 * v) - 1.0;
//    // アークタンジェントでx,y座標のラジアンを出す(-π ~ π)
//    float radian = atan2(smallUV.y, smallUV.x);
//    // スケーラー
//    float scaler = 3.0 * time;
//    float t1 = 0.2 * sin(5 * radian + scaler); // (-1 〜 1) * 0.2 => -0.2 ~ 0.2 の範囲になる。
    // uvの原点との距離
//    float len = length(smallUV);
    //t1を比べて描画するかしないかを決定
//    float stepValue = step(length(smallUV), t1);// 0 か 1
    // 0.6とかが入る。
//    float smallStar = 0.6 * v * stepValue;

    // vの値を0.1から0.8の間にClampする
//    uv *= 0.8 / clamp(v, 0.1, 0.8);
// (x,y座標の)ラジアン作成
    float radian = atan2(uv.y, uv.x);
    float t2 = 0.2 * sin(5 * radian);
    t2 += 0.8;// -0.6 ~ 0.6の間くらい。
    
    // uvのベクトルの大きさ　uvはすでに正規化されており、真ん中が原点になっている。
    float len = length(uv);
    // 0大きければ描画しない。lenを閾値としてlenより小さければ0を返す。それ以外は1
    float star = step(len, t2); // 0 ~ 1

    // 黄色
    float4 yellow = float4(1.0, 1.0, 0.0, 1.0);

// starを閾値としてmix(線形補間する)する。 => x(1 -a) + y * a HLSLだとLerｐになるでい
    return mix(0, yellow, star);
}
