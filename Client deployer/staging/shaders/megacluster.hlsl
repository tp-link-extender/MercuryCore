#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;
    float3 Normal	    : NORMAL;
    float4 Uv		    : TEXCOORD0;
    float4 EdgeDistances: TEXCOORD1;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;

    float4 UvHigh_EdgeDistance1 : TEXCOORD0;
    float4 UvLow_EdgeDistance2  : TEXCOORD1;

    float4 Diffuse_Specular	: COLOR0;

    float4 LightPosition_Fog : TEXCOORD2;
    float4 Position_Depth    : TEXCOORD3;
};

uniform float3 CameraPosition;
uniform float4x4 ViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;
uniform float3 AmbientColor;

uniform float3 FogColor;
uniform float4 FogParams;

uniform float4 LightConfig0;
uniform float4 LightConfig1;
uniform float4 LightConfig2;
uniform float4 LightConfig3;
uniform float4 LightBorder;
uniform float3 FadeDistance;
uniform float2 OutlineBrightness;

uniform float4x4 WorldMatrix;

VertexOutput MegaClusterVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;
    
    // Decode vertex data
    IN.Normal = (IN.Normal - 127) / 127;
    IN.Uv /= 1024;

    // Transform position and normal to world space
    // Note: world matrix does not contain rotation/scale for static geometry so we can avoid transforming normal
	float3 posWorld = mul(WorldMatrix, IN.Position).xyz;
    float3 normalWorld = IN.Normal;

    float ndotl = dot(normalWorld, -Lamp0Dir);

	OUT.HPosition = mul(ViewProjection, float4(posWorld, 1));

    float3 diffuse = saturate(ndotl) * Lamp0Color + max(-ndotl, 0) * Lamp1Color;

    OUT.Diffuse_Specular = float4(diffuse, 0);

    OUT.LightPosition_Fog = float4(lgridPrepareSample(lgridOffset(posWorld, normalWorld), LightConfig0, LightConfig1), (FogParams.z - OUT.HPosition.w) * FogParams.w);
    OUT.Position_Depth = float4(posWorld, OUT.HPosition.w * FadeDistance.y);

    OUT.UvHigh_EdgeDistance1.xy = IN.Uv.xy;
    OUT.UvLow_EdgeDistance2.xy = IN.Uv.zw;

#if defined(PIN_HQ)
    float4 edgeDistances = IN.EdgeDistances*FadeDistance.z + 0.5 * OUT.Position_Depth.w;

    OUT.UvHigh_EdgeDistance1.zw = edgeDistances.xy;
    OUT.UvLow_EdgeDistance2.zw = edgeDistances.zw;
#endif

	return OUT;
}

sampler2D DiffuseHighMap: register(s0);
sampler2D DiffuseLowMap: register(s1);
LGRID_SAMPLER LightMap: register(s2);
sampler2D LightMapLookup: register(s3);

void MegaClusterPS(VertexOutput IN,
#ifdef PIN_GBUFFER
    out float4 oColor1: COLOR1,
#endif
    out float4 oColor0: COLOR0)
{
    // Compute albedo term
    float4 high = tex2D(DiffuseHighMap, IN.UvHigh_EdgeDistance1);
    float4 low = tex2D(DiffuseLowMap, IN.UvLow_EdgeDistance2);

    float3 albedo = lerp(low.rgb, high.rgb, high.a);

    float4 light = lgridSample(LightMap, LightMapLookup, IN.LightPosition_Fog.xyz, LightConfig2, LightConfig3, LightBorder);

    // For some reason, terrain ambient was multiplied by 0.5
    float ambientFactor = 0.5;

    // Compute diffuse term
    float3 diffuse = (AmbientColor * ambientFactor + IN.Diffuse_Specular.rgb * light.a + light.rgb) * albedo.rgb;

    // Combine
    oColor0.rgb = diffuse;
    oColor0.a = 1;

#ifdef PIN_HQ
	float outlineFade = saturate1(IN.Position_Depth.w * OutlineBrightness.x + OutlineBrightness.y);
	float2 minIntermediate = min(IN.UvHigh_EdgeDistance1.wz, IN.UvLow_EdgeDistance2.wz);
	float minEdgesPlus = min(minIntermediate.x, minIntermediate.y) / IN.Position_Depth.w;
	oColor0.rgb *= saturate1(outlineFade *(1.5 - minEdgesPlus) + minEdgesPlus);
#endif

    float fogAlpha = saturate(IN.LightPosition_Fog.w);

#ifdef GLSL
    // Manually apply fog in GLSL path
    oColor0.rgb = lerp(FogColor, oColor0.rgb, fogAlpha);
#endif

#ifdef PIN_GBUFFER
    oColor1 = gbufferPack(IN.Position_Depth.w*FadeDistance.x, diffuse.rgb, 0, fogAlpha);
#endif
}
