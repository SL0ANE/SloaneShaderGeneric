#ifndef INCLUDED_RANDOM
#include "Random.hlsl"
#endif

float perlin(float3 p, float3 freq, float3 rep, float3 offset)
{
    p += offset / freq;
    p *= freq;
    float3 gridSet = floor(p) + float3(0.0, 0.0, 0.0);
    float3 dirSet = frac(p) - float3(0.0, 0.0, 0.0);
    // 必要时保证噪声在连接处连续
    gridSet = fmod(gridSet, rep * freq);
    
    float3 gridLevel_000 = hash33(gridSet);
    float3 gridLevel_001 = hash33(gridSet + float3(0.0, 0.0, 1.0));
    float3 gridLevel_010 = hash33(gridSet + float3(0.0, 1.0, 0.0));
    float3 gridLevel_011 = hash33(gridSet + float3(0.0, 1.0, 1.0));
    float3 gridLevel_100 = hash33(gridSet + float3(1.0, 0.0, 0.0));
    float3 gridLevel_101 = hash33(gridSet + float3(1.0, 0.0, 1.0));
    float3 gridLevel_110 = hash33(gridSet + float3(1.0, 1.0, 0.0));
    float3 gridLevel_111 = hash33(gridSet + float3(1.0, 1.0, 1.0));
    
    float product_000 = dot(gridLevel_000, dirSet);
    float product_001 = dot(gridLevel_001, dirSet - float3(0.0, 0.0, 1.0));
    float product_010 = dot(gridLevel_010, dirSet - float3(0.0, 1.0, 0.0));
    float product_011 = dot(gridLevel_011, dirSet - float3(0.0, 1.0, 1.0));
    float product_100 = dot(gridLevel_100, dirSet - float3(1.0, 0.0, 0.0));
    float product_101 = dot(gridLevel_101, dirSet - float3(1.0, 0.0, 1.0));
    float product_110 = dot(gridLevel_110, dirSet - float3(1.0, 1.0, 0.0));
    float product_111 = dot(gridLevel_111, dirSet - float3(1.0, 1.0, 1.0));
    
    float t_0 = pow(dirSet.x, 3.0) * (6.0 * pow(dirSet.x, 2.0) - 15.0 * dirSet.x + 10.0);
    float t_1 = pow(dirSet.y, 3.0) * (6.0 * pow(dirSet.y, 2.0) - 15.0 * dirSet.y + 10.0);
    float t_2 = pow(dirSet.z, 3.0) * (6.0 * pow(dirSet.z, 2.0) - 15.0 * dirSet.z + 10.0);
    
    float mix_x0 = lerp(product_000, product_100, t_0);
    float mix_x1 = lerp(product_010, product_110, t_0);
    float mix_y0 = lerp(mix_x0, mix_x1, t_1);
    
    float mix_x2 = lerp(product_001, product_101, t_0);
    float mix_x3 = lerp(product_011, product_111, t_0);
    float mix_y1 = lerp(mix_x2, mix_x3, t_1);
    
    return lerp(mix_y0, mix_y1, t_2);
}
