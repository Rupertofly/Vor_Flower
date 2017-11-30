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
Voronoi vor = new Voronoi();
ToxiclibsSupport gfx;
PGraphics source;
PGraphics wScan;
PGraphics hScan;
PShader scanner;
float cellCount = 0.0;
ArrayList<FPoint> points = new ArrayList<FPoint>();
void settings() {
  size(720,720,P2D);
  smooth(16);
}
void setup() {
  background(MyPallete.g("charcoal"));
  vor.addPoint(new Vec2D(width/2,height/2));
  points.add(new FPoint(width/2,height/2,MyPallete.r(),0));
  scanner = loadShader("scanner.glsl");
  source = createGraphics(720,720,P2D);
  source.smooth(8);
  gfx = new ToxiclibsSupport(this,source);
}

void draw() {
  image(source,0,0);
}

void mousePressed() {
  vor.addPoint(new Vec2D(mouseX,mouseY));
  points.add(new FPoint(mouseX,mouseY,MyPallete.r(),points.size()));
  cellCount ++;
  redrawsource();

}
void prepwork() {

}
void redrawsource() {
  source.beginDraw();
  source.stroke(255);
  source.strokeWeight(cellCount);
  source.clear();
  int count = 0;
  for (Triangle2D poly : vor.getTriangles()) {
    println("points.size: "+vor.getRegions());
    //FPoint data = points.get(count);
    source.fill(MyPallete.r());
    gfx.triangle(poly);
    count++;
  }
  source.endDraw();
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