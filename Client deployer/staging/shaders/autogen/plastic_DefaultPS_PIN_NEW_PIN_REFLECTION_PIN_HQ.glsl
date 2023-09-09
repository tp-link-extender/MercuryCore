varying vec3 xlv_TEXCOORD6;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_COLOR0;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform sampler2D NormalDetailMap;
uniform samplerCube EnvironmentMap;
uniform sampler2D NormalMap;
uniform sampler2D DiffuseMap;
uniform sampler3D LightMap;
uniform float Reflectance;
uniform vec2 OutlineBrightness;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
uniform vec3 Lamp1Color;
uniform vec3 Lamp0Color;
uniform vec3 Lamp0Dir;
void main ()
{
  vec4 oColor0_1;
  vec4 albedo_2;
  vec3 normal_3;
  vec2 tmpvar_4;
  tmpvar_4 = ((texture2D (NormalMap, xlv_TEXCOORD1.xy).wy * 2.0) - 1.0);
  vec3 tmpvar_5;
  tmpvar_5.xy = tmpvar_4;
  tmpvar_5.z = sqrt(clamp ((1.0 + dot (-(tmpvar_4), tmpvar_4)), 0.0, 1.0));
  normal_3.z = tmpvar_5.z;
  normal_3.xy = (tmpvar_4 + (((texture2D (NormalDetailMap, xlv_TEXCOORD0.xy).wy * 2.0) - 1.0) * (clamp ((xlv_COLOR0.w - 0.5), 0.0, 1.0) * clamp ((1.0 - (2.0 * Reflectance)), 0.0, 1.0))));
  normal_3.xy = (normal_3.xy * clamp ((1.0 - xlv_TEXCOORD3.w), 0.0, 1.0));
  vec3 tmpvar_6;
  tmpvar_6 = ((xlv_COLOR0.xyz * texture2D (DiffuseMap, xlv_TEXCOORD1.xy).xyz) * 2.0);
  vec4 tmpvar_7;
  tmpvar_7.xyz = tmpvar_6;
  tmpvar_7.w = xlv_COLOR0.w;
  albedo_2.w = tmpvar_7.w;
  vec3 tmpvar_8;
  tmpvar_8 = normalize((((normal_3.x * xlv_TEXCOORD6) + (normal_3.y * ((xlv_TEXCOORD4.yzx * xlv_TEXCOORD6.zxy) - (xlv_TEXCOORD4.zxy * xlv_TEXCOORD6.yzx)))) + (tmpvar_5.z * xlv_TEXCOORD4.xyz)));
  float tmpvar_9;
  tmpvar_9 = dot (tmpvar_8, -(Lamp0Dir));
  vec3 tmpvar_10;
  tmpvar_10 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  vec3 t_11;
  t_11.x = float((tmpvar_10.x >= LightConfig3.x));
  t_11.y = float((tmpvar_10.y >= LightConfig3.y));
  t_11.z = float((tmpvar_10.z >= LightConfig3.z));
  float tmpvar_12;
  tmpvar_12 = clamp (dot (t_11, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_13;
  tmpvar_13 = mix (texture3D (LightMap, (xlv_TEXCOORD2.yzx - (xlv_TEXCOORD2.yzx * tmpvar_12))), LightBorder, vec4(tmpvar_12));
  vec3 i_14;
  i_14 = -(xlv_TEXCOORD3.xyz);
  albedo_2.xyz = mix (tmpvar_6, textureCube (EnvironmentMap, (i_14 - (2.0 * (dot (tmpvar_8, i_14) * tmpvar_8)))).xyz, vec3(Reflectance));
  oColor0_1.xyz = ((((AmbientColor + (((clamp (tmpvar_9, 0.0, 1.0) * Lamp0Color) + (max (-(tmpvar_9), 0.0) * Lamp1Color)) * tmpvar_13.w)) + tmpvar_13.xyz) * albedo_2.xyz) + (Lamp0Color * (((float((tmpvar_9 >= 0.0)) * 0.4) * tmpvar_13.w) * pow (clamp (dot (tmpvar_8, normalize((-(Lamp0Dir) + normalize(xlv_TEXCOORD3.xyz)))), 0.0, 1.0), 9.0))));
  oColor0_1.w = albedo_2.w;
  vec2 tmpvar_15;
  tmpvar_15 = min (xlv_TEXCOORD0.wz, xlv_TEXCOORD1.wz);
  float tmpvar_16;
  tmpvar_16 = (min (tmpvar_15.x, tmpvar_15.y) / xlv_TEXCOORD3.w);
  oColor0_1.xyz = (oColor0_1.xyz * clamp (((clamp (((xlv_TEXCOORD3.w * OutlineBrightness.x) + OutlineBrightness.y), 0.0, 1.0) * (1.5 - tmpvar_16)) + tmpvar_16), 0.0, 1.0));
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

