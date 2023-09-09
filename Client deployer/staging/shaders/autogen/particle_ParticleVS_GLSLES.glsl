varying highp vec4 xlv_TEXCOORD1;
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
  highp vec4 tmpvar_2;
  tmpvar_2 = (WorldViewProjection * vertex);
  tmpvar_1.xy = (((tmpvar_2.xy / tmpvar_2.w) * vec2(0.5, -0.5)) + vec2(0.5, 0.5));
  tmpvar_1.z = tmpvar_2.w;
  tmpvar_1.w = ((FogParams.z - tmpvar_2.w) * FogParams.w);
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = uv0;
  xlv_COLOR0 = colour;
  xlv_TEXCOORD1 = tmpvar_1;
}

