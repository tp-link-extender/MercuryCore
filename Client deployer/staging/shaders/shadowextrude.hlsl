#include "common.h"

struct Appdata
{
    float4 Position	    : POSITION;

    int4   BoneIndices  : COLOR0;
};

struct VertexOutput
{
    float4 HPosition    : POSITION;
};

uniform float4x4 ViewProjection;
uniform float3 Lamp0Dir;
uniform float ShadowExtrusionDistance;

uniform float4 WorldMatrixArray[MAX_BONE_COUNT * 3];

VertexOutput DefaultVS(Appdata IN)
{
    VertexOutput OUT = (VertexOutput)0;

    int boneIndex = IN.BoneIndices.r;

    float4 worldRow0 = WorldMatrixArray[boneIndex * 3 + 0];
    float4 worldRow1 = WorldMatrixArray[boneIndex * 3 + 1];
    float4 worldRow2 = WorldMatrixArray[boneIndex * 3 + 2];

	float3 posWorld = float3(dot(worldRow0, IN.Position), dot(worldRow1, IN.Position), dot(worldRow2, IN.Position));

    float3 extrusion = Lamp0Dir * (ShadowExtrusionDistance * IN.BoneIndices.g);

	OUT.HPosition = mul(ViewProjection, float4(posWorld + extrusion, 1));

	return OUT;
}

float4 DefaultPS(): COLOR0
{
    return float4(0, 0, 0, 1);
}
