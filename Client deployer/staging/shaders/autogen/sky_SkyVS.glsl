varying vec4 xlv_COLOR0;
varying vec2 xlv_TEXCOORD0;
attribute vec4 colour;
attribute vec2 uv0;
attribute vec4 vertex;
uniform mat4 WorldViewProjection;
void main ()
{
  vec4 tmpvar_1;
  vec4 tmpvar_2;
  tmpvar_2 = (WorldViewProjection * vertex);
  tmpvar_1.xyw = tmpvar_2.xyw;
  tmpvar_1.z = (tmpvar_2.w - 1e-05);
  gl_Position = tmpvar_1;
  gl_PointSize = 2.0;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = colour;
}

