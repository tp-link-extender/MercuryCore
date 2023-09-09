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

#ifdef GLSL
    float FogFactor     : TEXCOORD1;
#endif
};

uniform float4x4 World;
uniform float4x4 WorldViewProjection;

uniform float3 FogColor;
uniform float4 FogParams;

VertexOutput UIVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    OUT.HPosition = mul(WorldViewProjection, IN.Position);

    OUT.Uv = IN.Uv;
    OUT.Color = IN.Color;

#ifdef GLSL
    OUT.FogFactor = 1;
#endif

    return OUT;
}

VertexOutput UIFogVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    OUT.HPosition = mul(WorldViewProjection, IN.Position);

    OUT.Uv = IN.Uv;
    OUT.Color = IN.Color;

#ifdef GLSL
    OUT.FogFactor = (FogParams.z - OUT.HPosition.w) * FogParams.w;
#endif

    return OUT;
}

sampler2D DiffuseMap: register(s0);

float4 UIFontPS(VertexOutput IN): COLOR0
{
    float4 base = tex2D(DiffuseMap, IN.Uv);
    float4 result = float4(IN.Color.rgb, base.a * IN.Color.a);

#ifdef GLSL
    // Manually apply fog in GLSL path
    result.rgb = lerp(FogColor, result.rgb, saturate(IN.FogFactor));
#endif

    return result;
}

float4 UITexturePS(VertexOutput IN): COLOR0
{
    float4 base = tex2D(DiffuseMap, IN.Uv);
    float4 result = float4(base.rgb, base.a * IN.Color.a);

#ifdef GLSL
    // Manually apply fog in GLSL path
    result.rgb = lerp(FogColor, result.rgb, saturate(IN.FogFactor));
#endif

    return result;
}

float4 UIColorPS(VertexOutput IN): COLOR0
{
    float4 result = IN.Color;

#ifdef GLSL
    // Manually apply fog in GLSL path
    result.rgb = lerp(FogColor, result.rgb, saturate(IN.FogFactor));
#endif

    return result;
}
