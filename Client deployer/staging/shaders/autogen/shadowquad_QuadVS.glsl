attribute vec4 vertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyw = vertex.xyw;
  tmpvar_1.z = 0.5;
  gl_Position = tmpvar_1;
}

