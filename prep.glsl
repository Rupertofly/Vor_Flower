#version 140
uniform vec2 iResolution;
uniform float fIndex;
uniform sampler2D texIn;
uniform sampler2D pIn;
uniform float fJump;
out vec4 FragColor;

vec2 decodeP(in vec4 color){
  vec2 coord = vec2(0.0);
  float r = (color.r * 255.0);
  float g = (color.g * 255.0);
  float b = (color.b * 255.0);
  float a = (color.a * 255.0);
  coord.x = (r * 255.0 + g);
  coord.y = (b * 255.0 + a);
  return coord;
}