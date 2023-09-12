varying float xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec3 normal;
attribute vec2 uv0;
attribute vec4 vertex;
uniform vec4 Color;
uniform vec4 FogParams;
uniform mat4 WorldViewProjection;
uniform mat4 InvWorldView;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = InvWorldView[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(tmpvar_1);
  float tmpvar_3;
  tmpvar_3 = dot (tmpvar_2, normal);
  vec4 tmpvar_4;
  tmpvar_4 = (WorldViewProjection * vertex);
  vec4 tmpvar_5;
  tmpvar_5.xyz = clamp (((((tmpvar_3 * 0.25) + 0.75) * Color.xyz) + (pow (dot (normalize((tmpvar_2 + normalize(tmpvar_1))), normal), 64.0) * tmpvar_3)), 0.0, 1.0);
  tmpvar_5.w = Color.w;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = tmpvar_5;
  xlv_TEXCOORD1 = ((FogParams.z - tmpvar_4.w) * FogParams.w);
}

