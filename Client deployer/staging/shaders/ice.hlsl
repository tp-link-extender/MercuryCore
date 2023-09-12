#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1.0
#define CFG_SPECULAR_SCALE              1.2
#define CFG_GLOSS_SCALE                 256
#define CFG_REFLECTION_SCALE          	0.3

#define CFG_NORMAL_SHADOW_SCALE         0

#define CFG_SPECULAR_LOD				1
#define CFG_GLOSS_LOD					190

#define CFG_NORMAL_DETAIL_TILING		0
#define CFG_NORMAL_DETAIL_SCALE			0

#define CFG_FAR_TILING					0.25
#define CFG_FAR_DIFFUSE_CUTOFF			0
#define CFG_FAR_NORMAL_CUTOFF			0
#define CFG_FAR_SPECULAR_CUTOFF			0.75

#define CFG_OPT_DIFFUSE_CONST

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	const float NoiseScale = 7.f / 3.f;

	float2 NormalUV = IN.Uv.xy * 0.01;
	float3 shiftPos = IN.SurfaceCoord.xyz;

	// low frequency
    float3 noiseval = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.1).xyz;
	float3 noiseval2 = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.5).xyz * 0.7 + 0.5;
	noiseval *= noiseval2;

	float3 dColor = IN.Color.xyz + (noiseval*0.35 - 0.15);
	
	float3 tNorm = tex2D(NormalMap,NormalUV).xyz - float3(0.5,0.5,0.5);
	float tNormSum = 0.85+0.15*dot(tNorm, 1);
	dColor *= tNormSum;

	tNorm.xy *= 0.15 * fade;

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color, dColor, fade);
    surface.normal = tNorm;
    surface.specular = 0.4;
    surface.gloss = 50;
    surface.reflectance = 0.275 * fade;

	return surface;
}
#endif
