varying highp vec4 xlv_COLOR1;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform samplerCube EnvironmentMap;
uniform sampler2D LightMapLookup;
uniform sampler2D LightMap;
uniform sampler2D StudsMap;
uniform highp float Reflectance;
uniform highp vec2 OutlineBrightness;
uniform highp vec4 LightBorder;
uniform highp vec4 LightConfig3;
uniform highp vec4 LightConfig2;
uniform highp vec3 FogColor;
uniform highp vec3 AmbientColor;
uniform highp vec3 Lamp0Color;
uniform highp vec3 Lamp0Dir;
void main ()
{
  highp vec4 oColor0_1;
  highp vec3 reflection_2;
  highp vec4 albedo_3;
  highp vec4 studs_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (StudsMap, xlv_TEXCOORD1.xy);
  studs_4 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.xyz = mix (xlv_COLOR0.xyz, studs_4.xyz, studs_4.www);
  tmpvar_6.w = xlv_COLOR0.w;
  albedo_3.w = tmpvar_6.w;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize(xlv_TEXCOORD4.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  highp vec3 t_9;
  t_9.x = float((tmpvar_8.x >= LightConfig3.x));
  t_9.y = float((tmpvar_8.y >= LightConfig3.y));
  t_9.z = float((tmpvar_8.z >= LightConfig3.z));
  highp float tmpvar_10;
  tmpvar_10 = min (dot (t_9, vec3(1.0, 1.0, 1.0)), 1.0);
  highp vec4 s1_11;
  highp vec4 s0_12;
  highp vec4 offsets_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (LightMapLookup, xlv_TEXCOORD2.xy);
  offsets_13 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2.yz * 0.125);
  highp vec2 tmpvar_16;
  tmpvar_16 = (tmpvar_15 - (tmpvar_15 * tmpvar_10));
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = (tmpvar_16 + offsets_13.xy);
  tmpvar_17 = texture2D (LightMap, P_18);
  s0_12 = tmpvar_17;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = (tmpvar_16 + offsets_13.zw);
  tmpvar_19 = texture2D (LightMap, P_20);
  s1_11 = tmpvar_19;
  highp vec4 tmpvar_21;
  tmpvar_21 = mix (mix (s0_12, s1_11, vec4(fract((xlv_TEXCOORD2.x * 64.0)))), LightBorder, vec4(tmpvar_10));
  highp vec3 tmpvar_22;
  highp vec3 i_23;
  i_23 = -(xlv_TEXCOORD3.xyz);
  tmpvar_22 = (i_23 - (2.0 * (dot (tmpvar_7, i_23) * tmpvar_7)));
  lowp vec3 tmpvar_24;
  tmpvar_24 = textureCube (EnvironmentMap, tmpvar_22).xyz;
  reflection_2 = tmpvar_24;
  albedo_3.xyz = mix (tmpvar_6.xyz, reflection_2, vec3(Reflectance));
  oColor0_1.xyz = ((((AmbientColor + (xlv_COLOR1.xyz * tmpvar_21.w)) + tmpvar_21.xyz) * albedo_3.xyz) + (Lamp0Color * ((xlv_COLOR1.w * tmpvar_21.w) * pow (clamp (dot (tmpvar_7, normalize((-(Lamp0Dir) + normalize(xlv_TEXCOORD3.xyz)))), 0.0, 1.0), xlv_TEXCOORD4.w))));
  oColor0_1.w = albedo_3.w;
  highp vec2 tmpvar_25;
  tmpvar_25 = min (xlv_TEXCOORD0.wz, xlv_TEXCOORD1.wz);
  highp float tmpvar_26;
  tmpvar_26 = (min (tmpvar_25.x, tmpvar_25.y) / xlv_TEXCOORD3.w);
  oColor0_1.xyz = (oColor0_1.xyz * min (((min (((xlv_TEXCOORD3.w * OutlineBrightness.x) + OutlineBrightness.y), 1.0) * (1.5 - tmpvar_26)) + tmpvar_26), 1.0));
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

