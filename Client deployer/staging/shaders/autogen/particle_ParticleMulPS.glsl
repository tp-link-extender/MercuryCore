varying vec4 xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
uniform vec3 FogColor;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (texture2D (DiffuseMap, xlv_TEXCOORD0) * xlv_COLOR0);
  vec4 color_2;
  color_2.w = tmpvar_1.w;
  color_2.xyz = mix (FogColor, tmpvar_1.xyz, vec3(clamp (xlv_TEXCOORD1.w, 0.0, 1.0)));
  gl_FragData[0] = color_2;
}

