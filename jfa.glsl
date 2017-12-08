#version 140
uniform vec2 iResolution;
uniform float fIndex;
uniform sampler2D texIn;
uniform float fJump;
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
  vec2 nPos = denat(gl_FragCoord.xy);
  vec2 adj[9];
    adj[0] = vec2(-1.,-1.);
    adj[1] = vec2(0.,-1.);
    adj[2] = vec2(1.,-1.);
    adj[3] = vec2(-1.,0.);
    adj[4] = vec2(0.,0.);
    adj[5] = vec2(1.,0.);
    adj[6] = vec2(-1.,1.);
    adj[7] = vec2(0.,1.);
    adj[8] = vec2(1.,1.);
  vec2 jump = vec2(fJump,fJump);
  float minDist = 1000.0;
  vec4 outputColor = vec4(0.0);
  for (int i = 0; i < 9; i++){
    vec2 offset = adj[i]*jump;
    vec2 sampleCoord = denat(nPos+offset);
    if (sampleCoord.x >= iResolution.x || sampleCoord.y >= iResolution.y) continue;
    if (sampleCoord.x < 0.0 || sampleCoord.y < 0.0) continue;
    vec4 sample = texture(texIn,uvise(sampleCoord));
    if (sample.w < 0.1) continue;
    vec2 seedCoord = myDecode(sample.rgb);
    float thisDist = distance(nPos,seedCoord);
    if (thisDist < minDist) {
      minDist = thisDist;
      outputColor = sample;
    }
  }
  FragColor = outputColor;

}

