#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              2.7
#define CFG_GLOSS_SCALE                 256
#define CFG_REFLECTION_SCALE          	0

#define CFG_NORMAL_SHADOW_SCALE         0.5

#define CFG_SPECULAR_LOD				0.9
#define CFG_GLOSS_LOD					160

#define CFG_NORMAL_DETAIL_TILING		0
#define CFG_NORMAL_DETAIL_SCALE			0

#define CFG_FAR_TILING					0
#define CFG_FAR_DIFFUSE_CUTOFF			0
#define CFG_FAR_NORMAL_CUTOFF			0
#define CFG_FAR_SPECULAR_CUTOFF			0

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	float3 normal = 2 * tex2D(NormalMap, IN.Uv * 1.2).xyz - 1;

    float3 dColor = IN.Color.rgb;

	float tNormSum = 0.9+dot(0.1, normal);
	dColor *= tNormSum;

	normal.xy *= 0.3 * fade;

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color, dColor, fade);
    surface.normal = normal;
    surface.specular = 0.9;
    surface.gloss = 25;

	return surface;
}
#endif
