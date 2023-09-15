varying highp float xlv_TEXCOORD1;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform highp vec3 FogColor;
void main ()
{
  highp vec4 result_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * xlv_COLOR0);
  result_1.w = tmpvar_3.w;
  result_1.xyz = mix (FogColor, tmpvar_3.xyz, vec3(clamp (xlv_TEXCOORD1, 0.0, 1.0)));
  gl_FragData[0] = result_1;
}

