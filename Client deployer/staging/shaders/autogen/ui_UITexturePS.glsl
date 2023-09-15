varying float xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform vec3 FogColor;
void main ()
{
  vec4 result_1;
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (DiffuseMap, xlv_TEXCOORD0);
  vec4 tmpvar_3;
  tmpvar_3.xyz = tmpvar_2.xyz;
  tmpvar_3.w = (tmpvar_2.w * xlv_COLOR0.w);
  result_1.w = tmpvar_3.w;
  result_1.xyz = mix (FogColor, tmpvar_2.xyz, vec3(clamp (xlv_TEXCOORD1, 0.0, 1.0)));
  gl_FragData[0] = result_1;
}

