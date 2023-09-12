varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 Color;
uniform sampler2D DiffuseMap;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  gl_FragData[0] = (tmpvar_1 * Color);
}

