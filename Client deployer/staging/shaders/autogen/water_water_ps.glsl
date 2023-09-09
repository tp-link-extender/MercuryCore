varying vec3 xlv_TEXCOORD3;
varying vec3 xlv_TEXCOORD2;
varying vec4 xlv_TEXCOORD1;
varying vec3 xlv_TEXCOORD0;
uniform sampler3D LightMap;
uniform sampler2D NormalMap1;
uniform vec3 Lamp0Color;
uniform vec4 LightBorder;
uniform vec4 LightConfig3;
uniform vec4 LightConfig2;
uniform vec4 AmbientColor;
uniform vec3 FogColor;
uniform vec4 WaterColor;
uniform vec4 CameraPosition;
void main ()
{
  vec3 normal_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (NormalMap1, xlv_TEXCOORD0.xy);
  normal_1.z = tmpvar_2.z;
  normal_1.xy = ((2.0 * tmpvar_2.wy) - 1.0);
  normal_1.z = sqrt((1.001 - clamp (dot (normal_1.xy, normal_1.xy), 0.0, 1.0)));
  vec3 tmpvar_3;
  tmpvar_3 = abs((xlv_TEXCOORD3 - LightConfig2.xyz));
  vec3 t_4;
  t_4.x = float((tmpvar_3.x >= LightConfig3.x));
  t_4.y = float((tmpvar_3.y >= LightConfig3.y));
  t_4.z = float((tmpvar_3.z >= LightConfig3.z));
  float tmpvar_5;
  tmpvar_5 = clamp (dot (t_4, vec3(1.0, 1.0, 1.0)), 0.0, 1.0);
  vec4 tmpvar_6;
  tmpvar_6 = mix (texture3D (LightMap, (xlv_TEXCOORD3.yzx - (xlv_TEXCOORD3.yzx * tmpvar_5))), LightBorder, vec4(tmpvar_5));
  vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = mix (FogColor, (mix ((WaterColor.xyz + (normal_1.z * 0.02)), vec3(0.6175, 0.8075, 0.8835), vec3(clamp (((-2.5 * abs(dot ((0.5 * (xlv_TEXCOORD2 + normal_1.xzy)), normalize((CameraPosition.xyz - xlv_TEXCOORD1.xyz))))) + 0.78), 0.0, 1.0))) * ((Lamp0Color * tmpvar_6.w) + (tmpvar_6.xyz + AmbientColor.xyz))), xlv_TEXCOORD0.zzz);
  gl_FragData[0] = tmpvar_7;
}

