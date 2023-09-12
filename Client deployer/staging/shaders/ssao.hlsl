#include "common.h"


// tweakables
#define SSAO_NUM_PAIRS         8
#define SSAO_SPHERE_RAD        2.0f   // world-space
#define SSAO_MIN_PIXEL_RANGE   10.0f
#define SSAO_MAX_PIXEL_RANGE   100.0f
#define BLUR_DEPTH_DELTA       0.4f

#define COMPOSITE_DEPTH_DELTA    0.02f              
#define COMPOSITE_DEPTH_DELTA2   0.4f

struct Appdata
{
    float4 p   : POSITION;
    float2 uv  : TEXCOORD0;
};

struct VertexOutput
{
    float4 p   : POSITION;
    float2 uv  : TEXCOORD0;
};

VertexOutput ssao_vs(Appdata IN)
{
    VertexOutput OUT;
    OUT.p = IN.p;
    OUT.p.z = 0;
    // clean up inaccuracies for the UV coords
    float2 uv = sign(IN.p.xy);
    // convert to image space
    uv = (float2(uv.x, -uv.y) + 1.0) * 0.5;
    OUT.uv = uv;
    return OUT;
}

// used for depth downsampling pass
struct VertexOutput_4uv
{
    float4 p    : POSITION;
    float2 uv   : TEXCOORD0;
	float4 uv12 : TEXCOORD1;
	float4 uv34 : TEXCOORD2;
};

VertexOutput_4uv ssaoDepthDown_vs( 
	Appdata IN, 
	
	uniform float4 invTexSize,
	uniform float4 stepScale
	)
{
    VertexOutput_4uv OUT;
    OUT.p = IN.p;
    OUT.p.z = 0;
    // clean up inaccuracies for the UV coords
    float2 uv = sign(IN.p.xy);
    // convert to image space
    uv = (float2(uv.x, -uv.y) + 1.0) * 0.5;

    OUT.uv = uv ; //+ float2(0.0002, 0.0002);
	OUT.uv12.xy = uv + float2( invTexSize.x, 0 ) * stepScale.xy;
	OUT.uv12.zw = uv - float2( invTexSize.x, 0 ) * stepScale.xy;
	OUT.uv34.xy = uv + float2( 0, invTexSize.y ) * stepScale.xy;
	OUT.uv34.zw = uv - float2( 0, invTexSize.y ) * stepScale.xy;

    return OUT;
}

struct VertexOutput_8uv
{
    float4 p    : POSITION;
    float2 uv   : TEXCOORD0;
	float4 uv12 : TEXCOORD1;
	float4 uv34 : TEXCOORD2;
	float4 uv56 : TEXCOORD3;
	float4 uv78 : TEXCOORD4;
};

// used for ssao blurring passes
VertexOutput_8uv ssaoBlur_vs( 
	Appdata IN, 
	
	uniform float4 stepShape,
	uniform float4 stepScale
	)
{
    VertexOutput_8uv OUT;
    OUT.p = IN.p;
    OUT.p.z = 0;
    // clean up inaccuracies for the UV coords
    float2 uv = sign(IN.p.xy);
    // convert to image space
    uv = (float2(uv.x, -uv.y) + 1.0) * 0.5;

    OUT.uv = uv;
	
	OUT.uv12.xy = uv + 1 * stepShape.xy * stepScale.xy;
	OUT.uv12.zw = uv + 2 * stepShape.xy * stepScale.xy;
	OUT.uv34.xy = uv + 3 * stepShape.xy * stepScale.xy;
	OUT.uv34.zw = uv + 4 * stepShape.xy * stepScale.xy;
	
	OUT.uv56.xy = uv - 1 * stepShape.xy * stepScale.xy;
	OUT.uv56.zw = uv - 2 * stepShape.xy * stepScale.xy;
	OUT.uv78.xy = uv - 3 * stepShape.xy * stepScale.xy;
	OUT.uv78.zw = uv - 4 * stepShape.xy * stepScale.xy;
	
    return OUT;
}

float unpackDepth( sampler2D s, float2 uv )
{
	float4 geomTex = tex2D(s, uv);
	float d = geomTex.z * (1.0f/256.0f) + geomTex.w;
	return d;
}

float getDepth( sampler2D s, float2 uv )
{
	return (float)tex2D(s,uv).r;
}

#define NUM_PAIRS   SSAO_NUM_PAIRS
#define RANGE 60.0/1024.0

#define pi 3.14159265359
#define RAD(X) ( (X) * (pi/180) )

float2 GetRotatedSample(float i)
{
	return (i+1) / (NUM_PAIRS+2) * float2(cos( RAD(45) + i / NUM_PAIRS * 2 * pi ), sin( RAD(45) + i / NUM_PAIRS * 2 * pi ) );
}

#define NUM_SAMPLES NUM_PAIRS*2+1

float4 ssao_ps(
    float2 uv: TEXCOORD0,
    uniform float4x4 ptMat,
    uniform float far,
    uniform float4 texSize,
    uniform sampler2D depthBuffer : TEXUNIT0,
    uniform sampler2D randMap  : TEXUNIT1): COLOR0
{
	
	float baseDepth = getDepth( depthBuffer, uv );
	
	float4 noiseTex = (float4)tex2D(randMap, frac(uv*texSize.xy /4));
	//noiseTex = (float4)tex2D( randMap, 100*noiseTex.xy )*2-1;
	
	noiseTex = noiseTex*2-1;
	
	float2x2 rotation = 
	{
		{ noiseTex.y, noiseTex.x },
		{ -noiseTex.x, noiseTex.y }
	};
	
	float2 OFFSETS1[NUM_PAIRS] =
	{
		GetRotatedSample(0),
		GetRotatedSample(1),
		GetRotatedSample(2),
		GetRotatedSample(3),
		GetRotatedSample(4),
		GetRotatedSample(5),
#if NUM_PAIRS > 6
		GetRotatedSample(6),
		GetRotatedSample(7),
#if NUM_PAIRS > 8
		GetRotatedSample(8),
		GetRotatedSample(9),
		GetRotatedSample(10),
		GetRotatedSample(11),
#endif
#endif
	};
	
	float occ = 1;
	
	float sphereRadiusZB = (float) ( 2.0f / GBUFFER_MAX_DEPTH );
	
#define MINPIXEL SSAO_MIN_PIXEL_RANGE
#define MAXPIXEL SSAO_MAX_PIXEL_RANGE
	
	float radiusTex = (float)clamp( 0.5*sphereRadiusZB / baseDepth, MINPIXEL / texSize.x, MAXPIXEL / texSize.x);
	
	float numSamples = 2;
	
	for(int i = 0; i < NUM_PAIRS; i++)
	{
		float2 offset1 = mul(rotation, OFFSETS1[i]);
	
		float2 offseted1 = uv + offset1 * radiusTex;
		float2 offseted2 = uv - offset1 * radiusTex;
		
		float2 offsetDepth;
		offsetDepth.x = getDepth( depthBuffer, offseted1 );
		offsetDepth.y = getDepth( depthBuffer, offseted2 );
		
		float2 diff = offsetDepth - baseDepth.xx;
		
		float normalizedOffsetLen = (float)(i+1)/(NUM_PAIRS+2);
		
		float segmentDiff = (float) ( 1.5f*sphereRadiusZB*sqrt(1-normalizedOffsetLen*normalizedOffsetLen) );
		
		float2 normalizedDiff = (diff / segmentDiff) + 0.5;
		
		float minDiff = min(normalizedDiff.x, normalizedDiff.y);
		
		// At 0, full sample
		// At -1, zero sample, zero weight
		
		float sampleadd = (float) saturate(1+minDiff);
		
		float a = (float)(saturate(normalizedDiff.x) + saturate(normalizedDiff.y))*sampleadd;
		occ += a;
		numSamples += 2 * sampleadd;
 	}
	
	occ = occ / numSamples;

	float finalocc = (float)saturate(occ*2);
	
	if(baseDepth - (1.0f-1/256.0f) > 0)
		finalocc += 1;
	
	return float4(finalocc, finalocc, finalocc, 1);
}

// this function estimates depth discrepancy tolerance for the blur filter
float depthTolerance( float baseDepth, float sphereRadiusZB )
{
	float ramp = 80; // tweak
	return (  clamp(  sphereRadiusZB * (baseDepth * ramp) , 0.1f * sphereRadiusZB, 40*sphereRadiusZB  ) );
}

float ssaoBlur(
	float2 uv,
	
	float4 uv12,
	float4 uv34,
	float4 uv56, 
	float4 uv78,

	sampler2D map, 
	sampler2D depthBuffer
	)
{
	float sphereRadiusZB = BLUR_DEPTH_DELTA / GBUFFER_MAX_DEPTH;
	float4 i = { 1, 2, 3, 4 };
	float4 iw = 4-i;
    float4 denom = 1;


    float4 sum = tex2D(map, uv).rrrr * denom;
	
	float baseDepth = getDepth( depthBuffer, uv );
	
	float4 newDepth, delta, ssample, coef;

	newDepth.x = getDepth( depthBuffer, uv12.xy );
	newDepth.y = getDepth( depthBuffer, uv12.zw );
	newDepth.z = getDepth( depthBuffer, uv34.xy );
	newDepth.w = getDepth( depthBuffer, uv34.zw );
	
	delta = (newDepth - baseDepth.xxxx);
	coef  = iw * ( abs(delta) < depthTolerance( baseDepth, sphereRadiusZB ).xxxx  );
	
	
	ssample.x = tex2D( map, uv12.xy ).r;
	ssample.y = tex2D( map, uv12.zw ).r;
	ssample.z = tex2D( map, uv34.xy ).r;
	ssample.w = tex2D( map, uv34.zw ).r;
	
	sum += ssample * coef;
	denom += coef;

	////////////////////////////////////////
	
	newDepth.x = getDepth( depthBuffer, uv56.xy );
	newDepth.y = getDepth( depthBuffer, uv56.zw );
	newDepth.z = getDepth( depthBuffer, uv78.xy );
	newDepth.w = getDepth( depthBuffer, uv78.zw );
	
	delta = newDepth - baseDepth.xxxx;
	coef  = iw * ( abs(delta) <  depthTolerance( baseDepth, sphereRadiusZB ).xxxx );
	
	ssample.x = tex2D( map, uv56.xy ).r;
	ssample.y = tex2D( map, uv56.zw ).r;
	ssample.z = tex2D( map, uv78.xy ).r;
	ssample.w = tex2D( map, uv78.zw ).r;
	
	sum += ssample * coef;
	denom += coef;
	
	return dot( sum, float4(1,1,1,1) ) / dot( denom, float4(1,1,1,1) );
}


float4 ssaoBlurX_ps(
	float2 uv : TEXCOORD0,
	float4 uv12 : TEXCOORD1,
	float4 uv34 : TEXCOORD2,
	float4 uv56 : TEXCOORD3,
	float4 uv78 : TEXCOORD4,
	
    uniform float4 invTexSize,
    uniform sampler2D map : register(s0), uniform sampler2D depthBuffer : register(s1) ): COLOR0
{
	//return tex2D( map, uv );
    float ssaoTerm = ssaoBlur( uv, uv12, uv34, uv56, uv78, map, depthBuffer);

    return float4(ssaoTerm.xxx, 1);
}

#define SPECULAR_WEIGHT 3


float4 ssaoBlurY_ps(
	float2 uv : TEXCOORD0,
	float4 uv12 : TEXCOORD1,
	float4 uv34 : TEXCOORD2,
	float4 uv56 : TEXCOORD3,
	float4 uv78 : TEXCOORD4,
	
    uniform float4 invTexSize,
    uniform sampler2D map : register(s0), uniform sampler2D depthBuffer : register(s1), uniform sampler2D geomMap : register(s2) ): COLOR0
{
	//return tex2D( map, uv );
	    
    float ssaoTerm = ssaoBlur(uv, uv12, uv34, uv56, uv78,  map, depthBuffer);
    //return float4(ssaoTerm.xxx, 1);

    float4 geom = tex2D(geomMap, uv);
    
    float specular = geom.x;
    float diffuse = geom.y;
	
    // Making specular kill SSAO faster, so it doesn't get capped by 1
    return (SPECULAR_WEIGHT*specular + diffuse * ssaoTerm) / (SPECULAR_WEIGHT*specular + diffuse + 0.001);
}



float4 ssaoDepthDown_ps( 
	float2 uv : TEXCOORD0, 
	float4 uv12 : TEXCOORD1,
	float4 uv34 : TEXCOORD2,
	
	uniform sampler2D depthBuffer : register(s0)  
) : COLOR0
{

	float4 d;
	d.x = unpackDepth( depthBuffer, uv12.xy );
	d.y = unpackDepth( depthBuffer, uv12.zw );
	d.z = unpackDepth( depthBuffer, uv34.xy );
	d.w = unpackDepth( depthBuffer, uv34.zw );
	
	float2 tmp = min( d.xy, d.zw );
	return min( tmp.x, tmp.y ).x;
}

float4 ssaoCompositBlank_ps(float2 uv : TEXCOORD0, uniform sampler2D colorMap : TEXUNIT0, uniform sampler2D map : TEXUNIT1): COLOR0
{
    return tex2D(colorMap, uv);
}
 
#define CMP_LESS(X,Y) (  (X) < (Y) )

float4 ssaoComposit_ps(
	float2 uv : TEXCOORD0,
	float4 uv12 : TEXCOORD1,
	float4 uv34 : TEXCOORD2,
	
	uniform float4 invTexSize,
	uniform sampler2D map :         register(s0), 
	uniform sampler2D colorMap :    register(s1),  
	uniform sampler2D gbuffer :     register(s2),
	uniform sampler2D depthBuffer:  register(s3)
	): COLOR0
{{
	//return float4(1,0,0,1);
	float depth_range  = COMPOSITE_DEPTH_DELTA / GBUFFER_MAX_DEPTH;
	float depth_range2 = COMPOSITE_DEPTH_DELTA2 / GBUFFER_MAX_DEPTH;

	// we're here
	float baseDepth = unpackDepth( gbuffer, uv );
	float4 ssaoTerm = 1.0f.xxxx; 

	float depth = getDepth( depthBuffer, uv );
	float diff = abs( depth - baseDepth );
	ssaoTerm = tex2D( map, uv );
	
	float chk1 = CMP_LESS( depth_range, diff );   // can we trust the base depth? 0 - yes, 1 - no
	float4 ssaoTermNew = 0, chk2, depth2, diff2; 

	depth2.x  = getDepth( depthBuffer, uv12.xy );
	depth2.y  = getDepth( depthBuffer, uv12.zw );
	depth2.z  = getDepth( depthBuffer, uv34.xy );
	depth2.w  = getDepth( depthBuffer, uv34.zw );

	ssaoTermNew.x = tex2D( map, uv12.xy ).x;
	ssaoTermNew.y = tex2D( map, uv12.zw ).x;
	ssaoTermNew.z = tex2D( map, uv34.xy ).x;
	ssaoTermNew.w = tex2D( map, uv34.zw ).x;

	diff2 = abs( depth2 - baseDepth.xxxx );
	chk2  = CMP_LESS( diff2, depth_range2.xxxx );
	
	ssaoTermNew *= chk2;
	float den = dot( chk2, 1 ); // + 1e-5f;    - TODO: add this if we encounter glitches; // 
	ssaoTermNew.x = dot( ssaoTermNew, 1 ) / den;

	// the final decision: pick the base sample or its estimate, if base depth in unauthorative
	ssaoTerm = saturate(den*chk1) ? ssaoTermNew.x :  ssaoTerm;

	return tex2D(colorMap, uv) * ssaoTerm;
}}
