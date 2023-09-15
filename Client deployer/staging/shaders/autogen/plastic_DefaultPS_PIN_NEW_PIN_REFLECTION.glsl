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
  tmpvar_3.xyz = ((xlv_COLOR0.xyz * texture2D (StudsMap, xlv_TEXCOORD1.xy).xyz) * 2.0);
  tmpvar_3.w = xlv_COLOR0.w;
  albedo_2.w = tmpvar_3.w;
  vec3 tmpvar_4;
  tmpvar_4 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  vec3 t_5;
  t_5.x = float((tmpvar_4.x >= LightConfig3.x));
  t_5.y = float((tmpvar_4.y >= LightConfig3.y));
  t_5.z = float((tmpvar_4.z >= LightConfig3.z));
  float tmpvar_6;
  tmpvar_6 = clamp (dot (t_5, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_7;
  tmpvar_7 = mix (texture3D (LightMap, (xlv_TEXCOORD2.yzx - (xlv_TEXCOORD2.yzx * tmpvar_6))), LightBorder, vec4(tmpvar_6));
  vec3 i_8;
  i_8 = -(xlv_TEXCOORD3.xyz);
  albedo_2.xyz = mix (tmpvar_3.xyz, textureCube (EnvironmentMap, (i_8 - (2.0 * (dot (xlv_TEXCOORD4.xyz, i_8) * xlv_TEXCOORD4.xyz)))).xyz, vec3(Reflectance));
  oColor0_1.xyz = ((((AmbientColor + (xlv_COLOR1.xyz * tmpvar_7.w)) + tmpvar_7.xyz) * albedo_2.xyz) + (Lamp0Color * (xlv_COLOR1.w * tmpvar_7.w)));
  oColor0_1.w = albedo_2.w;
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

