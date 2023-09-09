#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              1.3
#define CFG_GLOSS_SCALE                 128
#define CFG_REFLECTION_SCALE          	0

#define CFG_NORMAL_SHADOW_SCALE         0

#define CFG_SPECULAR_LOD				0.07
#define CFG_GLOSS_LOD					22

#define CFG_NORMAL_DETAIL_TILING		10
#define CFG_NORMAL_DETAIL_SCALE			1

#define CFG_FAR_TILING					0.25
#define CFG_FAR_DIFFUSE_CUTOFF			0.75
#define CFG_FAR_NORMAL_CUTOFF			0
#define CFG_FAR_SPECULAR_CUTOFF			0

#define CFG_OPT_NORMAL_CONST

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	float4 material = tex2D(DiffuseMap, IN.Uv * 0.18);

    Surface surface = (Surface)0;
    surface.albedo = IN.Color.rgb + (material.rgb - 0.5) * fade;
    surface.normal = float3(0, 0, 1);
    surface.specular = 0.19;
    surface.gloss = 14;

	return surface;
}
#endif
