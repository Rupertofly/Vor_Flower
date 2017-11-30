#version 140
uniform vec2 iResolution;
uniform float fIndex;
uniform sampler2D texIn;
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

void main(){

  vec2 fixCoord = vec2(gl_FragCoord.x-0.5,iResolution.y-(gl_FragCoord.y-0.5));
  vec2 thisUV = fixCoord.xy/(iResolution);
  vec4 thisCol = texture(texIn,thisUV);
  float minDist = 10000.0;
  vec4 outCol = vec4(0.0);
  for (float ix = -1.0;ix<2.0;ix++){
    float samX = (fixCoord.x+(ix*fJump))+0.5;
    if (samX > -1.0 && samX < iResolution.x){
      for (float iy = -1.0;iy<2.0;iy++){
        float samY = (fixCoord.y+(iy*fJump))+0.5;
        if (samY > -1.0 && samY < iResolution.y){
          vec2 samUV = vec2(samX/iResolution.x,samY/iResolution.y);
          vec4 samPxl = texture(texIn,samUV);
          vec2 samSeed = decodeP(samPxl);
          if (samSeed == vec2(0.0,0.0)) continue;
          float samDist = distance(samSeed,fixCoord);
          if (samDist < minDist) {
            minDist = samDist;
            outCol = samPxl;
          }
        }
      }
    }
  }
  FragColor = outCol;
}

