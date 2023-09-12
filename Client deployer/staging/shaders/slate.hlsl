#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              0.9
#define CFG_GLOSS_SCALE                 128
#define CFG_REFLECTION_SCALE          	0

#define CFG_NORMAL_SHADOW_SCALE         0.5

#define CFG_SPECULAR_LOD				0.14
#define CFG_GLOSS_LOD					20

#define CFG_NORMAL_DETAIL_TILING		5
#define CFG_NORMAL_DETAIL_SCALE			1

#define CFG_FAR_TILING					0.25
#define CFG_FAR_DIFFUSE_CUTOFF			0.75
#define CFG_FAR_NORMAL_CUTOFF			0
#define CFG_FAR_SPECULAR_CUTOFF			0

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	const float NoiseScale = 7;

	float3 normal = tex2D(NormalMap, IN.Uv.xy * 0.1).xyz - 0.5;

	float3 shiftPos = IN.SurfaceCoord.xyz;

    float3 noiseval = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.04).xyz;
	float3 noiseval2 = tex3D(NoiseMap,shiftPos.xyz/NoiseScale*0.3).xyz + 0.2;
	noiseval *= noiseval2;

	float3 dColor = IN.Color.xyz + (noiseval*0.4 - 0.08);

	float tNormSum = 0.9+dot(0.4, normal);
	dColor *= tNormSum;

    normal.xy *= fade;
	normal.z = 2;

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color.rgb, dColor, fade);
    surface.normal = normal;
    surface.specular = 0.1;
    surface.gloss = 40;

	return surface;
}	
#endif
