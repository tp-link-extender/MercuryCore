varying float xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec3 normal;
attribute vec2 uv0;
attribute vec4 vertex;
uniform vec4 Color;
uniform vec4 FogParams;
uniform vec3 AmbientColor;
uniform vec3 Lamp1Color;
uniform vec3 Lamp0Color;
uniform vec3 Lamp1Dir;
uniform vec3 Lamp0Dir;
uniform mat4 WorldViewProjection;
uniform mat4 World;
void main ()
{
  mat3 tmpvar_1;
  tmpvar_1[0] = World[0].xyz;
  tmpvar_1[1] = World[1].xyz;
  tmpvar_1[2] = World[2].xyz;
  vec3 tmpvar_2;
  tmpvar_2 = normalize((tmpvar_1 * normal));
  vec4 tmpvar_3;
  tmpvar_3 = (WorldViewProjection * vertex);
  vec4 tmpvar_4;
  tmpvar_4.xyz = (Color.xyz * ((AmbientColor + (clamp (dot (tmpvar_2, -(Lamp0Dir)), 0.0, 1.0) * Lamp0Color)) + (clamp (dot (tmpvar_2, -(Lamp1Dir)), 0.0, 1.0) * Lamp1Color)));
  tmpvar_4.w = Color.w;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = tmpvar_4;
  xlv_TEXCOORD1 = ((FogParams.z - tmpvar_3.w) * FogParams.w);
}

