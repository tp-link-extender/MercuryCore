varying vec2 xlv_TEXCOORD0;
attribute vec2 uv0;
attribute vec4 vertex;
uniform mat4 WorldViewProjection;
void main ()
{
  gl_Position = (WorldViewProjection * vertex);
  xlv_TEXCOORD0 = uv0;
}

