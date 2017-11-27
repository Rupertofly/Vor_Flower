uniform vec2 iResolution;
uniform float cellCount;
uniform sampler2D tex;

void main(){
  if (gl_FragCoord.x < cellCount){
    vec2 uv = gl_FragCoord.xy/iResolution;
    
  } else {
    gl_FragColor = vec4(0.0,0.0,0.0,0.0);
  }
}