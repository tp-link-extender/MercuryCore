attribute vec4 colour;
attribute vec4 vertex;
uniform vec4 WorldMatrixArray[216];
uniform float ShadowExtrusionDistance;
uniform vec3 Lamp0Dir;
uniform mat4 ViewProjection;
void main ()
{
  ivec4 tmpvar_1;
  tmpvar_1 = ivec4(colour);
  vec3 tmpvar_2;
  tmpvar_2.x = dot (WorldMatrixArray[(tmpvar_1.x * 3)], vertex);
  tmpvar_2.y = dot (WorldMatrixArray[((tmpvar_1.x * 3) + 1)], vertex);
  tmpvar_2.z = dot (WorldMatrixArray[((tmpvar_1.x * 3) + 2)], vertex);
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = (tmpvar_2 + (Lamp0Dir * (ShadowExtrusionDistance * float(tmpvar_1.y))));
  gl_Position = (ViewProjection * tmpvar_3);
}

