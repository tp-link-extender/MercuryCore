#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;
    float2 Uv	        : TEXCOORD0;
    float4 Color        : COLOR0;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;

    float2 Uv           : TEXCOORD0;
    float4 Color        : COLOR0;

    float4 ScreenPos_FogFactor: TEXCOORD1;
};

uniform float4x4 World;
uniform float4x4 WorldViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp1Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;
uniform float3 AmbientColor;

uniform float3 FogColor;
uniform float4 FogParams;

VertexOutput ParticleVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    OUT.HPosition = mul(WorldViewProjection, IN.Position);

    OUT.Uv = IN.Uv;
    OUT.Color = IN.Color;

    OUT.ScreenPos_FogFactor.xy = OUT.HPosition.xy / OUT.HPosition.w * float2(0.5, -0.5) + float2(0.5, 0.5);
    OUT.ScreenPos_FogFactor.z = OUT.HPosition.w;
    OUT.ScreenPos_FogFactor.w = (FogParams.z - OUT.HPosition.w) * FogParams.w;

    return OUT;
}

sampler2D DiffuseMap: register(s0);
sampler2D GBuffer: register(s1);

float4 particleBlend(float4 color, VertexOutput IN)
{
#ifdef PIN_GBUFFER
    // Apply GBuffer
	float2 bitShifts = float2(1, 1.0/256.0);
    
    float4 geomTex = tex2D(GBuffer, IN.ScreenPos_FogFactor.xy);
	float baseDepth = dot(geomTex.wz, bitShifts * GBUFFER_MAX_DEPTH);

    color.a *= saturate(baseDepth - IN.ScreenPos_FogFactor.z);
#endif

#ifdef GLSL
    // Manually apply fog in GLSL path
    color.rgb = lerp(FogColor, color.rgb, saturate(IN.ScreenPos_FogFactor.w));
#endif

    return color;
}

float4 ParticleMulPS(VertexOutput IN): COLOR0
{
    float4 base = tex2D(DiffuseMap, IN.Uv);
    float4 result = base * IN.Color;

    return particleBlend(result, IN);
}

float4 ParticleAddPS(VertexOutput IN): COLOR0
{
    float4 base = tex2D(DiffuseMap, IN.Uv);
    float4 result = float4(base.rgb + IN.Color.rgb, base.a * IN.Color.a);

    return particleBlend(result, IN);
}

float4 ParticleAddSignedPS(VertexOutput IN): COLOR0
{
    float4 base = tex2D(DiffuseMap, IN.Uv);
    float4 result = float4(base.rgb + IN.Color.rgb - 0.5, base.a * IN.Color.a);

    return particleBlend(result, IN);
}
