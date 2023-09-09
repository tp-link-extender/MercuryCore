varying float xlv_TEXCOORD1;
varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 colour;
attribute vec2 uv0;
attribute vec4 vertex;
uniform mat4 WorldViewProjection;
void main ()
{
  gl_Position = (WorldViewProjection * vertex);
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = colour;
  xlv_TEXCOORD1 = 1.0;
}

