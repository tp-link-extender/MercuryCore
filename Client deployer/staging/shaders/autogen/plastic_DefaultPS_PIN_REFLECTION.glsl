varying vec4 xlv_COLOR1;
varying vec4 xlv_TEXCOORD4;
varying vec4 xlv_TEXCOORD3;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_COLOR0;
varying vec4 xlv_TEXCOORD1;
uniform samplerCube EnvironmentMap;
uniform sampler3D LightMap;
uniform sampler2D StudsMap;
uniform float Reflectance;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
uniform vec3 Lamp0Color;
void main ()
{
  vec4 oColor0_1;
  vec4 albedo_2;
  vec4 tmpvar_3;
  tmpvar_3 = texture2D (StudsMap, xlv_TEXCOORD1.xy);
  vec4 tmpvar_4;
  tmpvar_4.xyz = mix (xlv_COLOR0.xyz, tmpvar_3.xyz, tmpvar_3.www);
  tmpvar_4.w = xlv_COLOR0.w;
  albedo_2.w = tmpvar_4.w;
  vec3 tmpvar_5;
  tmpvar_5 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  vec3 t_6;
  t_6.x = float((tmpvar_5.x >= LightConfig3.x));
  t_6.y = float((tmpvar_5.y >= LightConfig3.y));
  t_6.z = float((tmpvar_5.z >= LightConfig3.z));
  float tmpvar_7;
  tmpvar_7 = clamp (dot (t_6, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_8;
  tmpvar_8 = mix (texture3D (LightMap, (xlv_TEXCOORD2.yzx - (xlv_TEXCOORD2.yzx * tmpvar_7))), LightBorder, vec4(tmpvar_7));
  vec3 i_9;
  i_9 = -(xlv_TEXCOORD3.xyz);
  albedo_2.xyz = mix (tmpvar_4.xyz, textureCube (EnvironmentMap, (i_9 - (2.0 * (dot (xlv_TEXCOORD4.xyz, i_9) * xlv_TEXCOORD4.xyz)))).xyz, vec3(Reflectance));
  oColor0_1.xyz = ((((AmbientColor + (xlv_COLOR1.xyz * tmpvar_8.w)) + tmpvar_8.xyz) * albedo_2.xyz) + (Lamp0Color * (xlv_COLOR1.w * tmpvar_8.w)));
  oColor0_1.w = albedo_2.w;
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

