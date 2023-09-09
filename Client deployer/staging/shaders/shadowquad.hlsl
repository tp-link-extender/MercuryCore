struct Appdata
{
    float4 Position	    : POSITION;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;
};

uniform float4 Color;

VertexOutput QuadVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    OUT.HPosition = IN.Position;
    OUT.HPosition.z = 0.5; // force set depth to avoid depth clipping

	return OUT;
}

float4 QuadPS(): COLOR0
{
    return Color;
}
