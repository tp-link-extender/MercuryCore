// GLSLES has limited number of vertex shader registers so we have to use less bones
#ifdef GLSLES
#define MAX_BONE_COUNT 32
#else
#define MAX_BONE_COUNT 72
#endif

// PowerVR saturate() is compiled to min/max pair
// These are cross-platform specialized saturates that are free on PC and only cost 1 cycle on PowerVR
#ifdef GLSLES
float saturate0(float v) { return max(v, 0); }
float saturate1(float v) { return min(v, 1); }
#else
float saturate0(float v) { return saturate(v); }
float saturate1(float v) { return saturate(v); }
#endif

#define GBUFFER_MAX_DEPTH 500.0f 

float4 gbufferPack(float depth, float3 diffuse, float3 specular, float fog)
{
	depth = saturate(depth / GBUFFER_MAX_DEPTH);
	
	const float3 bitSh	= float3(255*255, 255, 1);
    const float3 lumVec = float3(0.299, 0.587, 0.114);

	float2 comp;
	comp = depth*float2(255,255*256);
	comp = frac(comp);
	comp = float2(depth,comp.x*256/255) - float2(comp.x, comp.y)/255;
	
	float4 result;
	
	result.r = lerp(1, dot(specular, lumVec), saturate(3 * fog));
	result.g = lerp(0, dot(diffuse, lumVec), saturate(3 * fog));
	result.ba = comp.yx;
	
	return result;
}

float3 lgridOffset(float3 v, float3 n)
{
    // cells are 4 studs in size
    // offset in normal direction to prevent self-occlusion
    // the offset has to be 1.5 cells in order to fully eliminate the influence of the source cell with trilinear filtering
    // (i.e. 1 cell is enough for point filtering, but is not enough for trilinear filtering)
    return v + n * (1.5f * 4.f);
}

float3 lgridPrepareSample(float3 c, float4 config0, float4 config1)
{
    // yxz swizzle is necessary for GLSLES sampling to work efficiently
    // (having .y as the first component allows to do the LUT lookup as a non-dependent texture fetch)
    return c.yxz * config0.xyz + config1.xyz;
}

#ifdef GLSLES
#define LGRID_SAMPLER sampler2D

float4 lgridFetch(LGRID_SAMPLER t, sampler2D lut, float3 data, float edgef)
{
    float4 offsets = tex2D(lut, data.xy);

    // texture is 64 pixels high
    // let's compute slice lerp coeff
    float slicef = frac(data.x * 64);

    // texture has 64 slices with 8x8 atlas setup
    float2 base = data.yz * 0.125;

    // replace base with 0 on edges to minimize texture cache misses
    base = base - base * edgef;

    float4 s0 = tex2D(t, base + offsets.xy);
    float4 s1 = tex2D(t, base + offsets.zw);

    return lerp(s0, s1, slicef);
}
#else
#define LGRID_SAMPLER sampler3D

float4 lgridFetch(LGRID_SAMPLER t, sampler2D lut, float3 data, float edgef)
{
    // replace data with 0 on edges to minimize texture cache misses
    return tex3D(t, data.yzx - data.yzx * edgef);
}
#endif

float4 lgridSample(LGRID_SAMPLER t, sampler2D lut, float3 data, float4 config2, float4 config3, float4 border)
{
    float3 edge = step(config3.xyz, abs(data - config2.xyz));
    float edgef = saturate1(dot(edge, 1));

    float4 light = lgridFetch(t, lut, data, edgef);

    return lerp(light, border, edgef);
}

#ifdef GLSLES
float3 nmapUnpack(float4 value)
{
    return value.rgb * 2 - 1;
}
#else
float3 nmapUnpack(float4 value)
{
    float2 xy = value.ag * 2 - 1;

    return float3(xy, sqrt(saturate(1 + dot(-xy, xy))));
}
#endif
