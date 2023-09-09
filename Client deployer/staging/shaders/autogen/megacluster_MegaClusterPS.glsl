varying vec4 xlv_TEXCOORD2;
varying vec4 xlv_COLOR0;
varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_TEXCOORD0;
uniform sampler3D LightMap;
uniform sampler2D DiffuseLowMap;
uniform sampler2D DiffuseHighMap;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec3 FogColor;
uniform vec3 AmbientColor;
void main ()
{
  vec4 oColor0_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseHighMap, xlv_TEXCOORD0.xy);
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
  oColor0_1.xyz = ((((AmbientColor * 0.5) + (xlv_COLOR0.xyz * tmpvar_6.w)) + tmpvar_6.xyz) * mix (texture2D (DiffuseLowMap, xlv_TEXCOORD1.xy).xyz, tmpvar_2.xyz, tmpvar_2.www));
  oColor0_1.w = 1.0;
  oColor0_1.xyz = mix (FogColor, oColor0_1.xyz, vec3(clamp (xlv_TEXCOORD2.w, 0.0, 1.0)));
  gl_FragData[0] = oColor0_1;
}

