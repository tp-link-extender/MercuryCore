#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              1
#define CFG_GLOSS_SCALE                 256
#define CFG_REFLECTION_SCALE          	0

#define CFG_NORMAL_SHADOW_SCALE         0.5

#define CFG_SPECULAR_LOD				0.17
#define CFG_GLOSS_LOD					18

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
	const float3 NoiseScale = float3(0.09, 0.02, 0.004) * 3;

	float spread = 0.3;
	float grass_threshold = 0.95;
	float NormalRatio = 0.15;
	float2 NormalUV = IN.Uv.xy * 0.1;
	
	float3 shiftPos = IN.SurfaceCoord.xyz;
	float3 ns = NoiseScale;
    float noiseval2 = tex3D(NoiseMap,shiftPos.xyz*ns.x).x * 0.4;
	float noiseval = tex3D(NoiseMap,shiftPos.zyx*ns.y).x * 0.6;
	noiseval -= noiseval2;
	float noiseval3 = tex3D(NoiseMap,shiftPos.xyz*ns.z).x * 0.3;
	noiseval += noiseval3;

	float interp = (noiseval - grass_threshold + spread)/2/spread+0.5;
	interp = clamp(interp,0,1);
	
    float3 grassColor = tex2D(DiffuseMap, NormalUV).xyz;
	float3 dirt = tex2D(NormalMap,NormalUV).xyz ;
	
	float3 dColor;

	dColor = lerp(grassColor+IN.Color.xyz-float3(0.31,0.43,0.146), dirt, interp);
    dColor = saturate(dColor);	

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color, dColor, fade);
    surface.normal = float3(0, 0, 1);
    surface.specular = 0.1;
    surface.gloss = 50;

	return surface;
}
#endif
