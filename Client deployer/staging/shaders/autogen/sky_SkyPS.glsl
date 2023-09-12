varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D DiffuseMap;
void main ()
{
  gl_FragData[0] = (texture2D (DiffuseMap, xlv_TEXCOORD0) * xlv_COLOR0);
}

