varying highp float xlv_TEXCOORD1;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform highp vec3 FogColor;
void main ()
{
  highp vec4 result_1;
  highp vec4 base_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  base_2 = tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.xyz = base_2.xyz;
  tmpvar_4.w = (base_2.w * xlv_COLOR0.w);
  result_1.w = tmpvar_4.w;
  result_1.xyz = mix (FogColor, base_2.xyz, vec3(clamp (xlv_TEXCOORD1, 0.0, 1.0)));
  gl_FragData[0] = result_1;
}

