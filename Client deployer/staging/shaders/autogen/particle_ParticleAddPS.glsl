varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform vec3 FogColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2.xyz = (tmpvar_1.xyz + xlv_COLOR0.xyz);
  tmpvar_2.w = (tmpvar_1.w * xlv_COLOR0.w);
  vec4 color_3;
  color_3.w = tmpvar_2.w;
  color_3.xyz = mix (FogColor, tmpvar_2.xyz, vec3(clamp (xlv_TEXCOORD1.w, 0.0, 1.0)));
  gl_FragData[0] = color_3;
}

