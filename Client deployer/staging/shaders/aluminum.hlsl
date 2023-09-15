#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              1
#define CFG_GLOSS_SCALE                 256
#define CFG_REFLECTION_SCALE          	0.6

#define CFG_NORMAL_SHADOW_SCALE         0

#define CFG_SPECULAR_LOD				0.94
#define CFG_GLOSS_LOD					240

#define CFG_NORMAL_DETAIL_TILING		0
#define CFG_NORMAL_DETAIL_SCALE			0

#define CFG_FAR_TILING					0.25
#define CFG_FAR_DIFFUSE_CUTOFF			0
#define CFG_FAR_NORMAL_CUTOFF			0.75
#define CFG_FAR_SPECULAR_CUTOFF			0

#define CFG_OPT_DIFFUSE_CONST

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	float2 NormalUV = IN.Uv * 0.2;
	float2 NormalUV2 = NormalUV * 0.4;
	float2 NormalUV3 = NormalUV2 * 0.1;

	float3 dColor = IN.Color.xyz;
	
	float3 tNorm = tex2D(NormalMap,NormalUV).xyz;
	float3 tNorm2 = tex2D(NormalMap, NormalUV2).xyz;
	tNorm = lerp(tNorm, tNorm2, 0.5);
	tNorm2 = tex2D(NormalMap, NormalUV3).xyz;
	tNorm = lerp(tNorm, tNorm2, 0.3);
	tNorm -= 0.5;
	
	float tNormSum = 0.4+dot(tNorm, 0.6);
	dColor *= tNormSum;

    tNorm.xy *= fade;

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color, dColor, fade);
    surface.normal = tNorm;
    surface.specular = 0.9;
    surface.gloss = 25;
    surface.reflectance = 0.35 * fade;

	return surface;
}
#endif
