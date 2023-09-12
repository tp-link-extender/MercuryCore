varying vec2 xlv_TEXCOORD0;
uniform vec4 Color;
uniform sampler2D DiffuseMap;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2.xyz = ((tmpvar_1.xyz * tmpvar_1.w) * Color.xyz);
  tmpvar_2.w = (tmpvar_1.w * Color.w);
  gl_FragData[0] = tmpvar_2;
}

