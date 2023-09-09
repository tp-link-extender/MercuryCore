varying highp float xlv_TEXCOORD1;
varying highp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
attribute vec4 colour;
attribute vec2 uv0;
attribute vec4 vertex;
uniform highp vec4 FogParams;
uniform highp mat4 WorldViewProjection;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (WorldViewProjection * vertex);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = colour;
  xlv_TEXCOORD1 = ((FogParams.z - tmpvar_1.w) * FogParams.w);
}

