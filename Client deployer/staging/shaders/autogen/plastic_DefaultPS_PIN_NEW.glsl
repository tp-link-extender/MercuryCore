varying vec4 xlv_COLOR1;
varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_COLOR0;
varying vec4 xlv_TEXCOORD1;
uniform sampler3D LightMap;
uniform sampler2D StudsMap;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
uniform vec3 Lamp0Color;
void main ()
{
  vec4 oColor0_1;
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((xlv_COLOR0.xyz * texture2D (StudsMap, xlv_TEXCOORD1.xy).xyz) * 2.0);
  tmpvar_2.w = xlv_COLOR0.w;
  vec3 tmpvar_3;
  tmpvar_3 = abs((xlv_TEXCOORD2.xyz - LightConfig2.xyz));
  vec3 t_4;
  t_4.x = float((tmpvar_3.x >= LightConfig3.x));
  t_4.y = float((tmpvar_3.y >= LightConfig3.y));
  t_4.z = float((tmpvar_3.z >= LightConfig3.z));
  float tmpvar_5;
  tmpvar_5 = clamp (dot (t_4, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_6;
  tmpvar_6 = mix (texture3D (LightMap, (xlv_TEXCOORD2.yzx - (xlv_TEXCOORD2.yzx * tmpvar_5))), LightBorder, vec4(tmpvar_5));
  oColor0_1.xyz = ((((AmbientColor + (xlv_COLOR1.xyz * tmpvar_6.w)) + tmpvar_6.xyz) * tmpvar_2.xyz) + (Lamp0Color * (xlv_COLOR1.w * tmpvar_6.w)));
  oColor0_1.w = tmpvar_2.w;
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

