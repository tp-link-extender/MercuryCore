#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;
    float3 Normal	    : NORMAL;
    float2 Uv	        : TEXCOORD0;
    float2 UvStuds	    : TEXCOORD1;

    float4 Color : COLOR0;

    // int4 produces better D3D asm, float4 produces better GLSL code
#ifdef GLSL
    float4 Extra : COLOR1;
#else
    int4   Extra : COLOR1;
#endif

#ifdef PIN_SURFACE
    #ifndef PIN_NEW
        float4 SurfaceCoord  : TEXCOORD2;
    #endif
    float3 Tangent       : TEXCOORD3;
#endif
	float4 EdgeDistances : TEXCOORD4;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;
    float4 Uv_EdgeDistance1 : TEXCOORD0;
	float4 UvStuds_EdgeDistance2 : TEXCOORD1;

    float4 Color             : COLOR0;
    float4 LightPosition_Fog : TEXCOORD2;

    #if defined(PIN_HQ) || defined(PIN_REFLECTION)
        float4 View_DepthMulFadeout : TEXCOORD3;
        float4 Normal_SpecPower  : TEXCOORD4;
    #endif
  
    #ifdef PIN_SURFACE
        #ifndef PIN_NEW
            float4 SurfaceCoord  : TEXCOORD5;
        #endif
        float3 Tangent  : TEXCOORD6;
    #else
        float4 Diffuse_Specular  : COLOR1;
    #endif
};

uniform float3 CameraPosition;
uniform float4x4 ViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp1Dir;
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

uniform float Reflectance;
uniform float2 SurfaceTiling;

#ifdef PIN_SKINNED
uniform float4 WorldMatrixArray[MAX_BONE_COUNT * 3];
#endif

#ifdef PIN_DEBUG
uniform float4 DebugColor;
#endif

VertexOutput DefaultVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    // Transform position and normal to world space
#ifdef PIN_SKINNED
    int boneIndex = IN.Extra.r;

    float4 worldRow0 = WorldMatrixArray[boneIndex * 3 + 0];
    float4 worldRow1 = WorldMatrixArray[boneIndex * 3 + 1];
    float4 worldRow2 = WorldMatrixArray[boneIndex * 3 + 2];
		
	float3 posWorld = float3(dot(worldRow0, IN.Position), dot(worldRow1, IN.Position), dot(worldRow2, IN.Position));
    float3 normalWorld = float3(dot(worldRow0.xyz, IN.Normal), dot(worldRow1.xyz, IN.Normal), dot(worldRow2.xyz, IN.Normal));
#else
	float3 posWorld = IN.Position.xyz;
    float3 normalWorld = IN.Normal;
#endif

    // Decode diffuse/specular parameters; encoding depends on the skinned flag due to vertex declaration differences
#if defined(PIN_DEBUG)
    float4 color = DebugColor;
#else
    float4 color = IN.Color;
#endif

    float specularIntensity = IN.Extra.g / 255.f;
    float specularPower = IN.Extra.b;

    float ndotl = dot(normalWorld, -Lamp0Dir);

#ifdef PIN_HQ
    // We'll calculate specular in pixel shader
    float2 lt = float2(saturate(ndotl), (ndotl > 0));
#else
    // Using lit here improves performance on software vertex shader implementations
    float2 lt = lit(ndotl, dot(normalize(-Lamp0Dir + normalize(CameraPosition - posWorld.xyz)), normalWorld), specularPower).yz;
#endif

	OUT.HPosition = mul(ViewProjection, float4(posWorld, 1));

#if defined(PIN_SURFACE) && defined(PIN_NEW)
	OUT.Uv_EdgeDistance1.xy = IN.Uv * SurfaceTiling;
#else
	OUT.Uv_EdgeDistance1.xy = IN.Uv;
#endif

	OUT.UvStuds_EdgeDistance2.xy = IN.UvStuds;

    OUT.Color = color;
    OUT.LightPosition_Fog = float4(lgridPrepareSample(lgridOffset(posWorld, normalWorld), LightConfig0, LightConfig1), (FogParams.z - OUT.HPosition.w) * FogParams.w);
    #if defined(PIN_HQ) || defined(PIN_REFLECTION)
        OUT.View_DepthMulFadeout = float4(CameraPosition - posWorld, OUT.HPosition.w * FadeDistance.y);
	    float4 edgeDistances = IN.EdgeDistances*FadeDistance.z + 0.5 * OUT.View_DepthMulFadeout.w;
	    OUT.Uv_EdgeDistance1.zw = edgeDistances.xy;
	    OUT.UvStuds_EdgeDistance2.zw = edgeDistances.zw;
        OUT.Normal_SpecPower = float4(normalWorld, specularPower);
    #endif

    #ifdef PIN_SURFACE
        #ifndef PIN_NEW
            OUT.SurfaceCoord = IN.SurfaceCoord;
        #endif

        #ifdef PIN_SKINNED
            float3 tangent = float3(dot(worldRow0.xyz, IN.Tangent), dot(worldRow1.xyz, IN.Tangent), dot(worldRow2.xyz, IN.Tangent));
        #else
            float3 tangent = IN.Tangent;
        #endif

        OUT.Tangent = tangent;
    #else
        float3 diffuse = lt.x * Lamp0Color + max(-ndotl, 0) * Lamp1Color;

        OUT.Diffuse_Specular = float4(diffuse, lt.y * specularIntensity);
    #endif

	return OUT;
}

#ifdef PIN_SURFACE
struct SurfaceInput
{
    float4 Color;
    float2 Uv;
    float2 UvStuds;

#ifndef PIN_NEW
    float4 SurfaceCoord;
#endif
};

struct Surface
{
    float3 albedo;
    float3 normal;
    float specular;
    float gloss;
    float reflectance;
};

Surface surfaceShader(SurfaceInput IN, float fade);

Surface surfaceShaderExec(VertexOutput IN)
{
    SurfaceInput SIN;
    SIN.Color = IN.Color;
    SIN.Uv = IN.Uv_EdgeDistance1.xy;
    SIN.UvStuds = IN.UvStuds_EdgeDistance2.xy;

#ifndef PIN_NEW
    SIN.SurfaceCoord = IN.SurfaceCoord;
#endif

    float fade = saturate0(1 - IN.View_DepthMulFadeout.w);

    return surfaceShader(SIN, fade);
}
#endif

sampler2D StudsMap: register(s0);
LGRID_SAMPLER LightMap: register(s1);
sampler2D LightMapLookup: register(s2);

sampler2D DiffuseMap: register(s3);
sampler2D NormalMap: register(s4);
samplerCUBE EnvironmentMap: register(s5);

#if !defined(GLSLES) && !defined(PIN_NEW)
sampler3D NoiseMap: register(s6);
#endif

#ifdef PIN_NEW
sampler2D SpecularMap: register(s6);
sampler2D NormalDetailMap: register(s7);
#endif

void DefaultPS(VertexOutput IN,
#ifdef PIN_GBUFFER
    out float4 oColor1: COLOR1,
#endif
    out float4 oColor0: COLOR0)
{
    // Compute albedo term
#ifdef PIN_SURFACE
    Surface surface = surfaceShaderExec(IN);

    #ifdef PIN_NEW
        float4 albedo = float4(surface.albedo, IN.Color.a);
    #else
        float4 studs = tex2D(StudsMap, IN.UvStuds_EdgeDistance2.xy);

        float4 albedo = float4(lerp(surface.albedo, studs.rgb, studs.a), IN.Color.a);
    #endif

    float3 bitangent = cross(IN.Normal_SpecPower.xyz, IN.Tangent.xyz);
    float3 normal = normalize(surface.normal.x * IN.Tangent.xyz + surface.normal.y * bitangent + surface.normal.z * IN.Normal_SpecPower.xyz);

    float ndotl = dot(normal, -Lamp0Dir);

    float3 diffuseIntensity = saturate0(ndotl) * Lamp0Color + max(-ndotl, 0) * Lamp1Color;
    float specularIntensity = step(0, ndotl) * surface.specular;
    float specularPower = surface.gloss;

    float reflectance = surface.reflectance;
#else
    #ifdef PIN_PLASTIC
        #ifdef PIN_NEW
            float4 studs = tex2D(StudsMap, IN.UvStuds_EdgeDistance2.xy);
            float4 albedo = float4(IN.Color.rgb * studs.rgb * 2, IN.Color.a);
        #else
            float4 studs = tex2D(StudsMap, IN.UvStuds_EdgeDistance2.xy);
            float4 albedo = float4(lerp(IN.Color.rgb, studs.rgb, studs.a), IN.Color.a);
        #endif
    #else
        float4 albedo = tex2D(DiffuseMap, IN.Uv_EdgeDistance1.xy) * IN.Color;
    #endif

    #ifdef PIN_HQ
        float3 normal = normalize(IN.Normal_SpecPower.xyz);
        float specularPower = IN.Normal_SpecPower.w;
    #elif defined(PIN_REFLECTION)
        float3 normal = IN.Normal_SpecPower.xyz;
    #endif

    float3 diffuseIntensity = IN.Diffuse_Specular.xyz;
    float specularIntensity = IN.Diffuse_Specular.w;

    #ifdef PIN_REFLECTION
        float reflectance = Reflectance;
    #endif

#endif

    float4 light = lgridSample(LightMap, LightMapLookup, IN.LightPosition_Fog.xyz, LightConfig2, LightConfig3, LightBorder);

    // Compute reflection term
#if defined(PIN_SURFACE) || defined(PIN_REFLECTION)
    float3 reflection = texCUBE(EnvironmentMap, reflect(-IN.View_DepthMulFadeout.xyz, normal)).rgb;

    albedo.rgb = lerp(albedo.rgb, reflection.rgb, reflectance);
#endif

    // Compute diffuse term
    float3 diffuse = (AmbientColor + diffuseIntensity * light.a + light.rgb) * albedo.rgb;

    // Compute specular term
#ifdef PIN_HQ
    float3 specular = Lamp0Color * (specularIntensity * light.a * (float)(half)pow(saturate(dot(normal, normalize(-Lamp0Dir + normalize(IN.View_DepthMulFadeout.xyz)))), specularPower));
#else
    float3 specular = Lamp0Color * (specularIntensity * light.a);
#endif

    // Combine
    oColor0.rgb = diffuse.rgb + specular.rgb;
    oColor0.a = albedo.a;

#ifdef PIN_HQ
	float outlineFade = saturate1(IN.View_DepthMulFadeout.w * OutlineBrightness.x + OutlineBrightness.y);
	float2 minIntermediate = min(IN.Uv_EdgeDistance1.wz, IN.UvStuds_EdgeDistance2.wz);
	float minEdgesPlus = min(minIntermediate.x, minIntermediate.y) / IN.View_DepthMulFadeout.w;
	oColor0.rgb *= saturate1(outlineFade *(1.5 - minEdgesPlus) + minEdgesPlus);
#endif

    float fogAlpha = saturate(IN.LightPosition_Fog.w);

#ifdef GLSL
    // Manually apply fog in GLSL path
    oColor0.rgb = lerp(FogColor, oColor0.rgb, fogAlpha);
#endif


#ifdef PIN_GBUFFER
    oColor1 = gbufferPack(IN.View_DepthMulFadeout.w*FadeDistance.x, diffuse.rgb, specular.rgb, fogAlpha);
#endif
}

