varying highp float xlv_TEXCOORD1;
varying highp vec4 xlv_COLOR0;
uniform highp vec3 FogColor;
void main ()
{
  highp vec4 result_1;
  result_1.w = xlv_COLOR0.w;
  result_1.xyz = mix (FogColor, xlv_COLOR0.xyz, vec3(clamp (xlv_TEXCOORD1, 0.0, 1.0)));
  gl_FragData[0] = result_1;
}

