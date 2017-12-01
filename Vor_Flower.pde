import toxi.audio.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.data.csv.*;
import toxi.data.feeds.*;
import toxi.data.feeds.util.*;
import toxi.doap.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh2d.*;
import toxi.geom.nurbs.*;
import toxi.image.util.*;
import toxi.math.*;
import toxi.math.conversion.*;
import toxi.math.noise.*;
import toxi.math.waves.*;
import toxi.music.*;
import toxi.music.scale.*;
import toxi.net.*;
import toxi.newmesh.*;
import toxi.nio.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.constraints.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.processing.*;
import toxi.sim.automata.*;
import toxi.sim.dla.*;
import toxi.sim.erosion.*;
import toxi.sim.fluids.*;
import toxi.sim.grayscott.*;
import toxi.util.*;
import toxi.util.datatypes.*;
import toxi.util.events.*;
import toxi.volume.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.util.*;
ToxiclibsSupport gfx;
PGraphics bPallete;
PGraphics bSource;
PGraphics bFront;
PGraphics bBack;
PGraphics bFinal;

PGraphics bXScan;
PGraphics bYScan;
PShader sJFA;
float cellCount = 0.0;
ArrayList<FPoint> aPointSet = new ArrayList<FPoint>();
void settings() {
  size(256,256,P3D);

}
void setup() {
  aPointSet.add(new FPoint(width/2,height/2,MyPallete.r(),0));
  sJFA = loadShader("jfa.glsl");
  bSource = createGraphics(width,height,P2D);
  bSource.noSmooth();
  bFront = createGraphics(width,height,P2D);
  bBack = createGraphics(width,height,P2D);
  bFinal = createGraphics(width,height,P2D);
  bPallete = createGraphics(width,height,P2D);
}

void draw() {
  background(0);
  image(bBack,0,0);
  image(bPallete,0,0);
}

void mouseClicked() {

  aPointSet.add(new FPoint(mouseX,mouseY,MyPallete.r(),aPointSet.size()));
  cellCount ++;
  redrawsource();
  println("cellCount: "+cellCount);
}

void prepwork() {

}
void redrawsource() {
  bSource.beginDraw();
  bSource.clear();
  for (int i = 0; i < aPointSet.size(); ++i) {
    FPoint c = aPointSet.get(i);
    bSource.set((int)c.x,(int)c.y,encodepos((int)c.x,(int)c.y));
  }
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
color encodepos(float _x, float _y) {
  color col = color(
                floor(_x / 255),
                (_x % 255),
                floor(_y / 255),
                (_y % 255));
  return col;
}
void jfa() {
  int steps = floor(log2(width));
  for (int indexPos = 0; indexPos < steps; ++indexPos) {
    float stepJump = pow(2, steps-indexPos -1);
    if (indexPos == 0) bBack = bSource;
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
    bFront.endDraw();
    bBack.beginDraw();
    bBack.clear();
    bBack.image(bFront,0,0);
    bBack.endDraw();
    println("stepJump: "+stepJump);
  }
}

float log2 (int x) {
  return (log(x) / log(2));
}