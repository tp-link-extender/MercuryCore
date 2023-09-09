#ifdef PIN_NEW
#define CFG_TEXTURE_TILING              1

#define CFG_DIFFUSE_SCALE               1
#define CFG_SPECULAR_SCALE              1
#define CFG_GLOSS_SCALE                 256
#define CFG_REFLECTION_SCALE          	0

#define CFG_NORMAL_SHADOW_SCALE         0.5

#define CFG_SPECULAR_LOD				0.35
#define CFG_GLOSS_LOD					103

#define CFG_NORMAL_DETAIL_TILING		0
#define CFG_NORMAL_DETAIL_SCALE			0

#define CFG_FAR_TILING					0.5
#define CFG_FAR_DIFFUSE_CUTOFF			0.75
#define CFG_FAR_NORMAL_CUTOFF			0
#define CFG_FAR_SPECULAR_CUTOFF			0

#define CFG_OPT_BLEND_COLOR

#include "material.hlsl"
#else
#define PIN_SURFACE
#include "default.hlsl"

Surface surfaceShader(SurfaceInput IN, float fade)
{
	const float3 NoiseScale = float3(0.02083, 0.0693, 0.2083) * 3;
	const float spread = 0.3;
	const float rust_threshold = 0.8;
	const float NormalRatio = 0.15;

	float3 normal = tex2D(NormalMap, IN.Uv.xy*0.15).xyz - 0.5;

	float3 shiftPos = IN.SurfaceCoord.xyz;
	
	float3 ns =NoiseScale;
    float noiseval = tex3D(NoiseMap,shiftPos.xyz*ns.x).x * 0.5;
	float noiseval2 = tex3D(NoiseMap,shiftPos.zyx*ns.y).x * 0.3;
	float noiseval3 = tex3D(NoiseMap,shiftPos.zyx*ns.z).x * 0.2;
	noiseval += noiseval2+noiseval3;

    float3 metalColor = IN.Color.rgb*1.3;
	float3 rustColor = tex2D(DiffuseMap, float2(0,1-noiseval)).xyz;
	
	float tNormSum = 0.65+dot(normal, 0.35);

	//Interpolate values between rust and metal    
	float interp = (noiseval - rust_threshold + spread)/2/spread+0.5;
	interp = saturate(interp);

	float3 dColor = lerp(rustColor, metalColor, interp);
	float3 dColor2 = dColor * tNormSum;
	dColor = lerp(dColor, dColor2, interp);

	normal.xy *= (1 - interp) * fade;

    Surface surface = (Surface)0;
    surface.albedo = lerp(IN.Color, dColor, fade);
    surface.normal = normal;
    surface.specular = lerp(0.12, 0.6, interp * fade);
    surface.gloss = 70;

	return surface;
}
#endif
