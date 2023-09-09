varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
attribute vec3 normal;
attribute vec4 vertex;
uniform vec2 FadeDistance;
uniform vec3 Lamp0Dir;
uniform vec4 LightConfig1;
uniform vec4 LightConfig0;
uniform vec4 FogParams;
uniform vec4 CameraPosition;
uniform vec4 waveParams;
uniform mat4 ViewProjection;
uniform mat4 World;
void main ()
{
  vec2 tcselect_1;
  vec4 wspos_2;
  vec3 tmpvar_3;
  vec3 tmpvar_4;
  vec2 tmpvar_5;
  vec3 tmpvar_6;
  tmpvar_6 = normalize(((normal - 127.0) / 127.0));
  vec4 tmpvar_7;
  tmpvar_7 = (World * vertex);
  wspos_2.xzw = tmpvar_7.xzw;
  wspos_2.y = (tmpvar_7.y - (2.0 * waveParams.z));
  vec4 wspos_8;
  wspos_8.xzw = wspos_2.xzw;
  float p_9;
  p_9 = ((sin((((tmpvar_7.z - tmpvar_7.x) - waveParams.y) * waveParams.x)) + sin((((tmpvar_7.z + tmpvar_7.x) + waveParams.y) * waveParams.x))) * waveParams.z);
  vec3 arg0_10;
  arg0_10 = (CameraPosition.xyz - wspos_2.xyz);
  wspos_8.y = (wspos_2.y + (p_9 - (p_9 * clamp ((-0.4 + ((1.4 * sqrt(dot (arg0_10, arg0_10))) * FadeDistance.y)), 0.0, 1.0))));
  wspos_2 = wspos_8;
  tmpvar_4 = tmpvar_6;
  if ((tmpvar_6.y < 0.01)) {
    tmpvar_4 = tmpvar_6;
  };
  vec3 tmpvar_11;
  tmpvar_11.x = wspos_8.x;
  tmpvar_11.y = -(wspos_8.y);
  tmpvar_11.z = wspos_8.z;
  tcselect_1.x = dot (abs(tmpvar_6.yxz), wspos_8.xzx);
  tcselect_1.y = dot (abs(tmpvar_6.yxz), tmpvar_11.zyy);
  vec4 tmpvar_12;
  tmpvar_12 = (ViewProjection * wspos_8);
  tmpvar_3.xy = (tcselect_1 * 0.05);
  tmpvar_3.z = clamp (((FogParams.z - tmpvar_12.w) * FogParams.w), 0.0, 1.0);
  vec3 arg0_13;
  arg0_13 = (CameraPosition.xyz - wspos_8.xyz);
  tmpvar_5.x = clamp ((-0.4 + ((1.4 * sqrt(dot (arg0_13, arg0_13))) * FadeDistance.y)), 0.0, 1.0);
  tmpvar_5.y = (((1.0 - tmpvar_5.x) * clamp (dot (tmpvar_6, -(Lamp0Dir)), 0.0, 1.0)) * 100.0);
  gl_Position = tmpvar_12;
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = wspos_8;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (((wspos_8.xyz + (tmpvar_6 * 6.0)).yxz * LightConfig0.xyz) + LightConfig1.xyz);
  xlv_TEXCOORD4 = tmpvar_5;
}

