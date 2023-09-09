varying vec2 xlv_TEXCOORD4;
varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler3D LightMap;
uniform samplerCube EnvMap;
uniform sampler2D NormalMap2;
uniform sampler2D NormalMap1;
uniform vec3 Lamp0Color;
uniform vec3 Lamp0Dir;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec4 AmbientColor;
uniform vec3 FogColor;
uniform vec4 WaterColor;
uniform vec4 CameraPosition;
uniform vec4 nmAnimLerp;
void main ()
{
  vec3 normal_1;
  vec4 tmpvar_2;
  tmpvar_2 = mix (texture2D (NormalMap1, xlv_TEXCOORD0.xy), texture2D (NormalMap2, xlv_TEXCOORD0.xy), nmAnimLerp.xxxx);
  normal_1.z = tmpvar_2.z;
  normal_1.xy = ((2.0 * tmpvar_2.wy) - 1.0);
  normal_1.z = sqrt((1.001 - clamp (dot (normal_1.xy, normal_1.xy), 0.0, 1.0)));
  vec3 tmpvar_3;
  tmpvar_3 = normalize((CameraPosition.xyz - xlv_TEXCOORD1.xyz));
  vec3 tmpvar_4;
  tmpvar_4 = abs((xlv_TEXCOORD3 - LightConfig2.xyz));
  vec3 t_5;
  t_5.x = float((tmpvar_4.x >= LightConfig3.x));
  t_5.y = float((tmpvar_4.y >= LightConfig3.y));
  t_5.z = float((tmpvar_4.z >= LightConfig3.z));
  float tmpvar_6;
  tmpvar_6 = clamp (dot (t_5, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_7;
  tmpvar_7 = mix (texture3D (LightMap, (xlv_TEXCOORD3.yzx - (xlv_TEXCOORD3.yzx * tmpvar_6))), LightBorder, vec4(tmpvar_6));
  vec3 i_8;
  i_8 = -(-(Lamp0Dir));
  vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = mix (FogColor, ((mix ((WaterColor.xyz + (normal_1.z * 0.02)), mix (textureCube (EnvMap, tmpvar_3), vec4(0.6175, 0.8075, 0.8835, 0.95), xlv_TEXCOORD4.xxxx).xyz, vec3(clamp (((-2.5 * abs(dot ((0.5 * (xlv_TEXCOORD2 + normal_1.xzy)), tmpvar_3))) + 0.78), 0.0, 1.0))) * ((Lamp0Color * tmpvar_7.w) + (tmpvar_7.xyz + AmbientColor.xyz))) + vec3(((pow (clamp (dot ((i_8 - (2.0 * (dot (normal_1.xzy, i_8) * normal_1.xzy))), tmpvar_3), 0.0, 1.0), 900.0) * clamp ((tmpvar_7.w - 0.4), 0.0, 1.0)) * xlv_TEXCOORD4.y))), xlv_TEXCOORD0.zzz);
  gl_FragData[0] = tmpvar_9;
}

