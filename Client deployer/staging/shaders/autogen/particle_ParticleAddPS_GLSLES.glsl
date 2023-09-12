varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform highp vec3 FogColor;
void main ()
{
  highp vec4 base_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  base_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.xyz = (base_1.xyz + xlv_COLOR0.xyz);
  tmpvar_3.w = (base_1.w * xlv_COLOR0.w);
  highp vec4 color_4;
  color_4.w = tmpvar_3.w;
  color_4.xyz = mix (FogColor, tmpvar_3.xyz, vec3(clamp (xlv_TEXCOORD1.w, 0.0, 1.0)));
  gl_FragData[0] = color_4;
}

