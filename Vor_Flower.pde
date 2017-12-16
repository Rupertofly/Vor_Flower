PGraphics bPallete;
PGraphics bSource;
PGraphics bFront;
PGraphics bBack;
PGraphics bFinal;

PGraphics bXScan;
PGraphics bYScan;
PShader sJFA;
PShader sFill;
float cellCount = 0.0;
ArrayList<FPoint> aPointSet = new ArrayList<FPoint>();
void settings() {
  size(1920,1080,OPENGL);
  noSmooth();

}
void setup() {
  aPointSet.add(new FPoint(width/2,height/2,rC(),0));
  sJFA = loadShader("jfa.glsl");
  sFill = loadShader("prep.glsl");
  bSource = createGraphics(width,height,P2D);
  bSource.noSmooth();
  bSource.beginDraw();
  bSource.clear();
  bSource.endDraw();
  bFront = createGraphics(width,height,P2D);
  bFront.noSmooth();
  bBack = createGraphics(width,height,P2D);
  bBack.noSmooth();
  bFinal = createGraphics(width,height,P2D);
  bFinal.noSmooth();
  bPallete = createGraphics(width,height,P2D);
  bBack.noSmooth();
  frameRate(120);
}

void draw() {
  redrawsource();
  processFinal();
  resetShader();
  noStroke();
  noFill();
  background(200,0,0);
  image(bFinal,0,0);
  //image(bPallete,0,0);
  image(bPallete,0,0);
  println("frameRate: "+frameRate);


}
void processFinal() {
  sFill.set("iResolution",(float)width,(float)height);
  sFill.set("texIn",bFront);
  sFill.set("pIn",bPallete);
  bFinal.beginDraw();
  bFinal.clear();
  bFinal.shader(sFill);
  bFinal.noStroke();
  bFinal.fill(256);
  bFinal.rect(0,0,width,height);
  bFinal.resetShader();
  bFinal.endDraw();
}


void mouseClicked() {

  aPointSet.add(new FPoint(mouseX,mouseY,rC(),aPointSet.size()));
  cellCount ++;
  redrawsource();
  println("cellCount: "+cellCount);
  bSource.save("source.png");
  bFinal.save("final.png");
}

void test() {
  bSource.beginDraw();
  bSource.resetShader();
  bSource.background(0,0);
  bSource.loadPixels();
  for (int i = 0; i < bSource.pixels.length; ++i) {
    int thisX = i%width;
    int thisY = floor(i/width);
    color thisC = encodepos(thisX,thisY);
    bSource.pixels[i] = thisC;
  }
  bSource.updatePixels();
  bSource.endDraw();
  bBack.beginDraw();
  bBack.image(bSource,0,0);
  bBack.endDraw();
  sJFA.set("iResolution",(float)width,(float)height);
  sJFA.set("texIn",bBack);
  bFront.beginDraw();
  bFront.clear();
  bFront.noStroke();
  bFront.fill(255);
  bFront.shader(sJFA);
  bFront.rect(0,0,width,height);
  bFront.resetShader();
  bFront.endDraw();
}
void redrawsource() {
  bSource.beginDraw();
  bSource.resetShader();
  bSource.background(0,0);
  bSource.loadPixels();
  for (int i = 0; i < aPointSet.size(); ++i) {
    FPoint c = aPointSet.get(i);
    color fill = encodepos(c.x,c.y);
    bSource.pixels[floor((c.y*width)+c.x)] = fill;
  }
  bSource.updatePixels();
  bSource.endDraw();
  bPallete.beginDraw();
  bPallete.clear();
  for (int i = 0; i < aPointSet.size(); ++i) {
    FPoint l = aPointSet.get(i);
    bPallete.noStroke();
    bPallete.fill(l.c);
    bPallete.ellipse((int)l.x,(int)l.y,3,3);
  }
  bPallete.endDraw();
  jfa();
}
public class FPoint {
  public float x,y;
  public int c;
  public int ind;
  FPoint(float _x, float _y, int _c, int _ind) {
    x = _x;
    y = _y;
    c = _c;
    ind = _ind;
  }
}
float frac(float _i) {
  return _i-floor(_i);
}
color encodepos(float _x, float _y) {
  float v1 = _x/256;
  float v1a = frac(v1)*256;
  float v1b = floor(v1);
  float v2 = _y/256;
  float v2a = frac(v2)*256;
  float v2b = floor(v2);
  float v3 = (v1b*16)+v2b;
  return color(v1a,v2a,v3,255);
}
void jfa() {
  int steps = floor(log2(width));
  bBack.beginDraw();
  bBack.resetShader();
  bBack.image(bSource,0,0);
  bBack.endDraw();
  for (int indexPos = 0; indexPos < steps; ++indexPos) {
    resetShader();
    float stepJump = pow(2, steps-indexPos -1);
    sJFA.set("iResolution",(float)width,(float)height);
    sJFA.set("texIn",bBack);
    sJFA.set("fIndex",(float)indexPos);
    sJFA.set("fJump",(float)stepJump);
    bFront.beginDraw();
    bFront.clear();
    bFront.noStroke();
    bFront.fill(255);
    bFront.shader(sJFA);
    bFront.rect(0,0,width,height);
    bFront.resetShader();
    bFront.endDraw();
    bBack.beginDraw();
    bBack.resetShader();
    bBack.clear();
    bBack.image(bFront,0,0);
    bBack.endDraw();
  }
}

float log2 (int x) {
  return (log(x) / log(2));
}
int rC() {
  return color(random(255),random(255),random(255));
}