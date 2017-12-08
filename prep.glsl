#version 140
uniform vec2 iResolution;
uniform sampler2D texIn;
uniform sampler2D pIn;
out vec4 FragColor;


vec2 uvise(vec2 _in){
  vec2 outp = _in/iResolution;
  return outp;
}
vec2 denat(vec2 _in){
  return vec2(_in.x,iResolution.y-_in.y);
}

vec2 naturalise(vec2 _in){
  vec2 outp = vec2(_in.x,iResolution.y-_in.y);
  return outp;
}
vec2 naturaliseUV (vec2 _in){
  return vec2(uvise(naturalise(_in)));
}


vec2 myDecode(in vec3 _in){
  vec3 initial = _in*255.0;
  float partA = floor(initial.b/16.0)*256.0;
  float partB = (fract(initial.b/16.0)*16.0)*256.0;
  return vec2(partA+initial.r,partB+initial.g);
}

void main(){
  vec2 uv = uvise(gl_FragCoord.xy);
  vec4 inputSam = texture(texIn,uv);
  vec2 palleteCoords = myDecode(inputSam.rgb);
  vec2 pUV = naturaliseUV(palleteCoords);
  FragColor = vec4(pUV,0.1,1.0);
  vec4 samTex = texture(pIn,pUV);
  if (samTex.r > 0.1){
    FragColor = samTex;
  }

}