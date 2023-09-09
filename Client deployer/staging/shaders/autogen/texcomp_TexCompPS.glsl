varying vec2 xlv_TEXCOORD0;
uniform vec4 Color;
uniform sampler2D DiffuseMap;
void main ()
{
  gl_FragData[0] = (texture2D (DiffuseMap, xlv_TEXCOORD0) * Color);
}

