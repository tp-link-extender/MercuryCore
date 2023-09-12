struct Appdata
{
    float4 Position	    : POSITION;
    float2 Uv	        : TEXCOORD0;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;
    float2 Uv           : TEXCOORD0;
};

uniform float4x4 WorldViewProjection;

VertexOutput TexCompVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    OUT.HPosition = mul(WorldViewProjection, IN.Position);
    OUT.Uv = IN.Uv;

    return OUT;
}

sampler2D DiffuseMap: register(s0);

uniform float4 Color;

float4 TexCompPS(VertexOutput IN): COLOR0
{
    return tex2D(DiffuseMap, IN.Uv) * Color;
}

float4 TexCompPMAPS(VertexOutput IN): COLOR0
{
    float4 tex = tex2D(DiffuseMap, IN.Uv);
    
    return float4(tex.rgb * tex.a * Color.rgb, tex.a * Color.a);
}
