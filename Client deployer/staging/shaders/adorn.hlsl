struct Appdata
{
    float4 Position	    : POSITION;
    float2 Uv	        : TEXCOORD0;
    float3 Normal       : NORMAL0;
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
uniform float4x4 InvWorldView;
uniform float4x4 WorldViewProjection;

uniform float3 Lamp0Dir;
uniform float3 Lamp1Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;
uniform float3 AmbientColor;

uniform float3 FogColor;
uniform float4 FogParams;

uniform float4 Color;

VertexOutput AdornSelfLitVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    float3 norm = IN.Normal;
    float3 lightVec = InvWorldView._13_23_33;

    float3 L = normalize(lightVec);
    float3 V = normalize(lightVec);
    float3 halfAngle = normalize(L + V);
    float NdotL = dot(L,norm);
    float NdotH = dot(halfAngle,norm);
    float diffuse = NdotL * 0.5 + 0.5;
    float specular = pow(NdotH,64.0) * NdotL * 0.5;
    float3 finalOut = saturate(diffuse * Color.rgb + specular);

    OUT.HPosition = mul(WorldViewProjection, IN.Position);
    OUT.Uv = IN.Uv;
    OUT.Color = float4(finalOut, Color.a);

#ifdef GLSL
    OUT.FogFactor = (FogParams.z - OUT.HPosition.w) * FogParams.w;
#endif

    return OUT;
}

VertexOutput AdornSelfLitHighlightVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    float3 norm = IN.Normal;
    float3 lightVec = InvWorldView._13_23_33;

    float3 L = normalize(lightVec);
    float3 V = normalize(lightVec);
    float3 halfAngle = normalize(L + V);
    float NdotL = dot(L,norm);
    float NdotH = dot(halfAngle,norm);
    float diffuse = NdotL * 0.25 + 0.75;
    float specular = pow(NdotH,64.0) * NdotL;
    float3 finalOut = saturate(diffuse * Color.rgb + specular);

    OUT.HPosition = mul(WorldViewProjection, IN.Position);
    OUT.Uv = IN.Uv;
    OUT.Color = float4(finalOut, Color.a);

#ifdef GLSL
    OUT.FogFactor = (FogParams.z - OUT.HPosition.w) * FogParams.w;
#endif

    return OUT;
}

VertexOutput AdornVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

#ifdef PIN_LIGHTING
    float3 normal = normalize(mul((float3x3)World, IN.Normal));
    float3 lighting = AmbientColor + saturate(dot(normal, -Lamp0Dir)) * Lamp0Color + saturate(dot(normal, -Lamp1Dir)) * Lamp1Color;
#else
    float3 lighting = 1;
#endif

    OUT.HPosition = mul(WorldViewProjection, IN.Position);
    OUT.Uv = IN.Uv;
    OUT.Color = float4(Color.rgb * lighting, Color.a);

#ifdef GLSL
    OUT.FogFactor = (FogParams.z - OUT.HPosition.w) * FogParams.w;
#endif

    return OUT;
}

sampler2D DiffuseMap: register(s0);

float4 AdornPS(VertexOutput IN): COLOR0
{
    float4 result = tex2D(DiffuseMap, IN.Uv) * IN.Color;

#ifdef GLSL
    // Manually apply fog in GLSL path
    result.rgb = lerp(FogColor, result.rgb, saturate(IN.FogFactor));
#endif

    return result;
}
