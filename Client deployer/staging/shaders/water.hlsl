
//
// Water shader.
// Big, fat and ugly.
//
// All (most) things considered, I have converged to this particular way of rendering water:
//
//   Vertex waves
//   No transparency. Solid color for deep water.
//   Fresnel law, reflects some static cubemap.
//   Phong speculars.
//   Ripples via animated normal map. Adjustable intensity, speed and scale. Affect reflection and speculars.

#include "common.h"

uniform float4x4 World;
uniform float4x4 ViewProjection;

uniform float4 nmAnimLerp; // ratio between normal map frames
uniform float4 waveParams; // .x = frequency  .y = phase  .z = height
uniform float4 CameraPosition;
uniform float4 WaterColor; // deep water color

uniform float3 FogColor;
uniform float4 FogParams;

uniform float4 AmbientColor;
uniform float4 LightConfig0;
uniform float4 LightConfig1;
uniform float4 LightConfig2;
uniform float4 LightConfig3;
uniform float4 LightBorder;

uniform float3 Lamp0Dir;
uniform float3 Lamp0Color;
uniform float3 Lamp1Color;

uniform float2 FadeDistance;

#ifdef PIN_HQ
#	define WATER_LOD 1
#else
#	define WATER_LOD 2
#endif

//#undef WATER_LOD
//#define WATER_LOD 0

float  fadeFactor( float3 wspos )
{
	return saturate( -0.4f + 1.4f*length( CameraPosition.xyz - wspos.xyz ) * FadeDistance.y );
}

float  wave( float4 wspos )
{
	float x = sin( ( wspos.z - wspos.x - waveParams.y ) * waveParams.x );
	float z = sin( ( wspos.z + wspos.x + waveParams.y ) * waveParams.x );
	float p = (x + z) * waveParams.z;
	return  p - p * fadeFactor( wspos.xyz );
}

// Fresnel approximation. N1 and N2 are refractive indices.
// for above water, use n1 = 1, n2 = 1.3, for underwater use n1 = 1.3, n2 = 1
// TODO: use mul/bias hack on ipad
float fresnel( float3 N, float3 V, float n1, float n2, float p, float fade )
{
#if WATER_LOD == 0
	float r0 = (n1-n2)/(n1+n2);
	r0 *= r0;
	return r0 + (1-r0) * pow( 1 - abs( dot( N, V ) ), p );
#else
	return saturate( - 2.5 * abs( dot( N, V ) ) + 0.78 ); // HAXX!
	//return 1 - 2 * abs( dot( N, V ) );
#endif
}

// perturbs the water mesh and vertex normals
// TODO: remove costly normal computations on ipad
void makeWaves( inout float4 wspos, inout float3 wsnrm )
{
#if WATER_LOD == 0 
	float gridSize = 4.0f;

	float4 wspos1 = wspos;
	float4 wspos2 = wspos;

	wspos1.x += gridSize;
	wspos2.z += gridSize;
	
	wspos.y  += wave(wspos) ;
	wspos1.y += wave(wspos1);
	wspos2.y += wave(wspos2);
	
	wsnrm = normalize( cross( wspos2.xyz - wspos.xyz, wspos1.xyz - wspos.xyz ) );
#elif WATER_LOD == 1
	wspos.y += wave( wspos );
#else   /* do n0thing */
#endif
}

struct V2P
{
	float4 pos    : POSITION;
	float3 tc0Fog : TEXCOORD0;
	float4 wspos  : TEXCOORD1;
	float3 wsnrm  : TEXCOORD2;
	float3 light  : TEXCOORD3;
	float2 fade   : TEXCOORD4;
};

V2P water_vs(
	float4 pos : POSITION,
	float3 nrm : NORMAL
)
{
	V2P o;

    // Decode vertex data
    nrm = (nrm - 127) / 127;

	nrm = normalize(nrm);
	
	float4 wspos = mul( World, pos );
	float3 wsnrm = nrm;
	
	wspos.y -= 2*waveParams.z;
	
	makeWaves( /*INOUT*/ wspos, /*INOUT*/ wsnrm );
	
	o.wspos = wspos;
	o.wsnrm = wsnrm;
	
	if( nrm.y < 0.01f ) o.wsnrm = nrm;

	// box mapping
	//float3x2 m = { wspos.xz, wspos.xy, wspos.yz };
	//float2 tcselect = mul( abs( nrm.yzx ), m );

	float2 tcselect;
	float3 wspostc = float3( wspos.x, -wspos.y, wspos.z );

	tcselect.x = dot( abs( nrm.yxz ), wspostc.xzx );
	tcselect.y = dot( abs( nrm.yxz ), wspostc.zyy );

	o.pos       = mul( ViewProjection, wspos );
	o.tc0Fog.xy = tcselect * .05f;
	o.tc0Fog.z  = saturate( (FogParams.z - o.pos.w) * FogParams.w );

	o.light = lgridPrepareSample( lgridOffset( wspos.xyz, wsnrm.xyz ), LightConfig0, LightConfig1 );
	
	o.fade.x = fadeFactor( wspos.xyz );
	o.fade.y = (1-o.fade.x) *  saturate( dot( wsnrm, -Lamp0Dir ) ) * 100;
	
	return o;
}

//////////////////////////////////////////////////////////////////////////////

sampler2D NormalMap1    : register(s0);
sampler2D NormalMap2    : register(s1);
samplerCUBE EnvMap      : register(s2);
LGRID_SAMPLER LightMap  : register(s3);
sampler2D LightMapLookup: register(s4);

float3 pixelNormal( float2 tc0 )
{
	float4 nm1 = tex2D( NormalMap1, tc0 );
#if WATER_LOD <= 1
	float4 nm2 = tex2D( NormalMap2, tc0 );
	float3 normal = lerp( nm1, nm2, nmAnimLerp.xxxx ).agb;
#else
	float3 normal = nm1.agb;
#endif
	//normal = nm2;
	normal.xy = 2*normal.xy - 1; 
	normal.z  = sqrt(  1.001 - saturate1( dot( normal.xy, normal.xy ) ) );
	return normal;
}


float4 envColor( float3 N, float3 V, float fade )
{
	float4 solidColor = float4( 0.65f, 0.85f, 0.93f, 1 )*.95f;
#if WATER_LOD > 1
	return solidColor;
#endif

	float3 dir = reflect( V, N );
	return lerp( texCUBE( EnvMap, V ), solidColor, fade );
	
	//return float3( 0.8f, 0.8f, 0.93f )*.91f;
}

//////////////////////////////////////////
//////////////////////////////////////////


 
float4 water_ps( V2P v ) : COLOR0
{
	float4 WaterColorTest = 0.5 * float4(  26, 169, 185, 0  ) / 255;
	float4 FogColorTest = 0.8 * float4( 35, 107, 130, 0 ) / 255;
	
	float3 N2 = v.wsnrm;
	float3 N1 = pixelNormal( v.tc0Fog.xy ).xzy;
	float3 N3 = 0.5f * (N2 + N1);
	
	float3 L = /*normalize*/(-Lamp0Dir.xyz);
	float3 E = normalize( CameraPosition.xyz - v.wspos.xyz );

	float4 light = lgridSample(LightMap, LightMapLookup, v.light.xyz, LightConfig2, LightConfig3, LightBorder);
	
	float3 ambient = ( light.rgb + AmbientColor.rgb );
	float  fre     =  fresnel( N3, E, 1.0f, 1.3f, 8, v.fade.x );
	float3 diffuse =  WaterColor.rgb  + N1.y*0.02f;
	
	float3 env = envColor( N3, E, v.fade.x ).rgb;
	
	float3 R = reflect( -L, N1 );
	
#if WATER_LOD <= 1
	float3 specular = pow( saturate( dot( R, E ) ), 900 ) * saturate( light.a - 0.4f ) * v.fade.y; // * (L.y * 100);
#else
	float3 specular = 0;
#endif

	float3 result = lerp( diffuse, env, fre ) * ( Lamp0Color.rgb * light.a + ambient ) + specular;
	result = lerp( FogColor.rgb, result, v.tc0Fog.z );
		
	return float4( result, 1 );
}
