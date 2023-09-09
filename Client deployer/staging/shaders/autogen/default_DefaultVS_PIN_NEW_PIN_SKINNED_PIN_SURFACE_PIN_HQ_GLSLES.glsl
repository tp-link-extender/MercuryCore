varying highp vec3 xlv_TEXCOORD6;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec4 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_COLOR0;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
attribute vec4 uv4;
attribute vec3 uv3;
attribute vec4 secondary_colour;
attribute vec4 colour;
attribute vec2 uv1;
attribute vec2 uv0;
attribute vec3 normal;
attribute vec4 vertex;
uniform highp vec4 WorldMatrixArray[96];
uniform highp vec2 SurfaceTiling;
uniform highp vec3 FadeDistance;
uniform highp vec4 LightConfig1;
uniform highp vec4 LightConfig0;
uniform highp vec4 FogParams;
uniform highp mat4 ViewProjection;
uniform highp vec3 CameraPosition;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  int tmpvar_3;
  tmpvar_3 = int(secondary_colour.x);
  highp vec4 tmpvar_4;
  tmpvar_4 = WorldMatrixArray[(tmpvar_3 * 3)];
  highp vec4 tmpvar_5;
  tmpvar_5 = WorldMatrixArray[((tmpvar_3 * 3) + 1)];
  highp vec4 tmpvar_6;
  tmpvar_6 = WorldMatrixArray[((tmpvar_3 * 3) + 2)];
  highp vec3 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_4, vertex);
  tmpvar_7.y = dot (tmpvar_5, vertex);
  tmpvar_7.z = dot (tmpvar_6, vertex);
  highp vec3 tmpvar_8;
  tmpvar_8.x = dot (tmpvar_4.xyz, normal);
  tmpvar_8.y = dot (tmpvar_5.xyz, normal);
  tmpvar_8.z = dot (tmpvar_6.xyz, normal);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_7;
  highp vec4 tmpvar_10;
  tmpvar_10 = (ViewProjection * tmpvar_9);
  tmpvar_1.xy = (uv0 * SurfaceTiling);
  tmpvar_2.xy = uv1;
  highp vec4 tmpvar_11;
  tmpvar_11.xyz = (((tmpvar_7 + (tmpvar_8 * 6.0)).yxz * LightConfig0.xyz) + LightConfig1.xyz);
  tmpvar_11.w = ((FogParams.z - tmpvar_10.w) * FogParams.w);
  highp vec4 tmpvar_12;
  tmpvar_12.xyz = (CameraPosition - tmpvar_7);
  tmpvar_12.w = (tmpvar_10.w * FadeDistance.y);
  highp vec4 tmpvar_13;
  tmpvar_13 = ((uv4 * FadeDistance.z) + (0.5 * tmpvar_12.w));
  tmpvar_1.zw = tmpvar_13.xy;
  tmpvar_2.zw = tmpvar_13.zw;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = tmpvar_8;
  tmpvar_14.w = secondary_colour.z;
  highp vec3 tmpvar_15;
  tmpvar_15.x = dot (tmpvar_4.xyz, uv3);
  tmpvar_15.y = dot (tmpvar_5.xyz, uv3);
  tmpvar_15.z = dot (tmpvar_6.xyz, uv3);
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_COLOR0 = colour;
  xlv_TEXCOORD2 = tmpvar_11;
  xlv_TEXCOORD3 = tmpvar_12;
  xlv_TEXCOORD4 = tmpvar_14;
  xlv_TEXCOORD6 = tmpvar_15;
}

