varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D SpecularMap;
uniform sampler2D NormalMap;
uniform sampler2D DiffuseMap;
uniform sampler2D LightMapLookup;
uniform sampler2D LightMap;
uniform highp vec2 OutlineBrightness;
uniform highp vec4 LightBorder;
uniform highp vec4 LightConfig3;
uniform highp vec4 LightConfig2;
uniform highp vec3 FogColor;
uniform highp vec3 AmbientColor;
uniform highp vec3 Lamp1Color;
uniform highp vec3 Lamp0Color;
uniform highp vec3 Lamp0Dir;
void main ()
{
  highp vec4 oColor0_1;
  highp vec4 albedo_2;
  highp float tmpvar_3;
  tmpvar_3 = max ((1.0 - xlv_TEXCOORD3.w), 0.0);
  highp vec3 normal_4;
  highp vec4 diffuse_5;
  highp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (DiffuseMap, xlv_TEXCOORD0.xy);
  tmpvar_6 = tmpvar_7;
  diffuse_5.w = tmpvar_6.w;
  diffuse_5.xyz = mix (vec3(1.0, 1.0, 1.0), tmpvar_6.xyz, vec3(tmpvar_3));
  highp vec4 tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (NormalMap, xlv_TEXCOORD0.xy);
  tmpvar_8 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((tmpvar_8.xyz * 2.0) - 1.0);
  normal_4.z = tmpvar_10.z;
  normal_4.xy = (tmpvar_10.xy * tmpvar_3);
  highp vec3 tmpvar_11;
  tmpvar_11 = ((xlv_COLOR0.xyz * diffuse_5.xyz) * (1.0 + (normal_4.x * 0.5)));
  highp vec4 tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (SpecularMap, xlv_TEXCOORD0.xy);
  tmpvar_12 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14 = mix (vec2(0.17, 18.0), ((tmpvar_12.xy * vec2(1.0, 256.0)) + vec2(0.0, 0.01)), vec2(tmpvar_3));
  highp vec4 tmpvar_15;
  tmpvar_15.xyz = tmpvar_11;
  tmpvar_15.w = xlv_COLOR0.w;
  albedo_2.w = tmpvar_15.w;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((((normal_4.x * xlv_TEXCOORD6) + (normal_4.y * ((xlv_TEXCOORD4.yzx * xlv_TEXCOORD6.zxy) - (xlv_TEXCOORD4.zxy * xlv_TEXCOORD6.yzx)))) + (tmpvar_10.z * xlv_TEXCOORD4.xyz)));
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_16, -(Lamp0Dir));
  highp vec3 tmpvar_18;
  tmpvar_18 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  highp vec3 t_19;
  t_19.x = float((tmpvar_18.x >= LightConfig3.x));
  t_19.y = float((tmpvar_18.y >= LightConfig3.y));
  t_19.z = float((tmpvar_18.z >= LightConfig3.z));
  highp float tmpvar_20;
  tmpvar_20 = min (dot (t_19, vec3(1.0, 1.0, 1.0)), 1.0);
  highp vec4 s1_21;
  highp vec4 s0_22;
  highp vec4 offsets_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (LightMapLookup, xlv_TEXCOORD2.xy);
  offsets_23 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25 = (xlv_TEXCOORD2.yz * 0.125);
  highp vec2 tmpvar_26;
  tmpvar_26 = (tmpvar_25 - (tmpvar_25 * tmpvar_20));
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = (tmpvar_26 + offsets_23.xy);
  tmpvar_27 = texture2D (LightMap, P_28);
  s0_22 = tmpvar_27;
  lowp vec4 tmpvar_29;
  highp vec2 P_30;
  P_30 = (tmpvar_26 + offsets_23.zw);
  tmpvar_29 = texture2D (LightMap, P_30);
  s1_21 = tmpvar_29;
  highp vec4 tmpvar_31;
  tmpvar_31 = mix (mix (s0_22, s1_21, vec4(fract((xlv_TEXCOORD2.x * 64.0)))), LightBorder, vec4(tmpvar_20));
  albedo_2.xyz = tmpvar_11;
  oColor0_1.xyz = ((((AmbientColor + (((max (tmpvar_17, 0.0) * Lamp0Color) + (max (-(tmpvar_17), 0.0) * Lamp1Color)) * tmpvar_31.w)) + tmpvar_31.xyz) * tmpvar_11) + (Lamp0Color * (((float((tmpvar_17 >= 0.0)) * tmpvar_14.x) * tmpvar_31.w) * pow (clamp (dot (tmpvar_16, normalize((-(Lamp0Dir) + normalize(xlv_TEXCOORD3.xyz)))), 0.0, 1.0), tmpvar_14.y))));
  oColor0_1.w = albedo_2.w;
  highp vec2 tmpvar_32;
  tmpvar_32 = min (xlv_TEXCOORD0.wz, xlv_TEXCOORD1.wz);
  highp float tmpvar_33;
  tmpvar_33 = (min (tmpvar_32.x, tmpvar_32.y) / xlv_TEXCOORD3.w);
  oColor0_1.xyz = (oColor0_1.xyz * min (((min (((xlv_TEXCOORD3.w * OutlineBrightness.x) + OutlineBrightness.y), 1.0) * (1.5 - tmpvar_33)) + tmpvar_33), 1.0));
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}
