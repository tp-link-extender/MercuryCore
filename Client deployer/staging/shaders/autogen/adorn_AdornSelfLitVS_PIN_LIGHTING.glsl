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
  mat3 tmpvar_1;
  tmpvar_1[0] = InvWorldView[0].xyz;
  tmpvar_1[1] = InvWorldView[1].xyz;
  tmpvar_1[2] = InvWorldView[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * vec3(0.0, 0.0, 1.0));
  vec3 tmpvar_3;
  tmpvar_3 = normalize(tmpvar_2);
  float tmpvar_4;
  tmpvar_4 = clamp (dot (tmpvar_3, normal), 0.0, 1.0);
  vec4 tmpvar_5;
  tmpvar_5 = (WorldViewProjection * vertex);
  vec4 tmpvar_6;
  tmpvar_6.xyz = ((((tmpvar_4 * 0.5) + 0.5) * Color.xyz) + ((pow (clamp (dot (normalize((tmpvar_3 + normalize(tmpvar_2))), normal), 0.0, 1.0), 64.0) * tmpvar_4) * 0.5));
  tmpvar_6.w = Color.w;
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = tmpvar_6;
  xlv_TEXCOORD1 = ((FogParams.z - tmpvar_5.w) * FogParams.w);
}

