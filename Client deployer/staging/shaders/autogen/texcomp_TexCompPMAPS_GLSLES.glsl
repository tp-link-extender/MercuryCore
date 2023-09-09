varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 Color;
uniform sampler2D DiffuseMap;
void main ()
{
  highp vec4 tex_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  tex_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.xyz = ((tex_1.xyz * tex_1.w) * Color.xyz);
  tmpvar_3.w = (tex_1.w * Color.w);
  gl_FragData[0] = tmpvar_3;
}

