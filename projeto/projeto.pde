PShape can;
float angle;
PShader colorShader;
 
void setup() {
  fullScreen(P3D);
  //can = createCan(100, 200, 32);
}
 
void draw() {
  background(0);
  //lights();
 
  translate(width/2, height/2);
  camera(0.0, -200.0, 200.0, 0.0, 0.0, 0.0, 0, -1, 0);
  //rotateY(angle);
  //rotateX(.7);
  lights();
  fill(255);
  noStroke();
  
  base();
  
}
 
//-------------------------------------------------------------------------
 
//PShape createCan(float r, float h, int detail) {
 
//  textureMode(NORMAL);
//  PShape sh = createShape();
 
//  sh.beginShape(QUAD_STRIP);
 
//  sh.noStroke();
//  sh.fill(255, 0, 0); 
//  for (int i = 0; i <= detail; i++) {
//    float angle = TWO_PI / detail;
//    float x = sin(i * angle);
//    float z = cos(i * angle);
//    float u = float(i) / detail;
//    sh.normal(x, 0, z);
//    sh.vertex(x * r, -h/2, z * r, u, 0);
//    sh.vertex(x * r, +h/2, z * r, u, 1);
//  }
//  sh.endShape();
//  return sh;
//}

void base() {
  float u = height / 100;
  float[] x = new float[6];
  float[] y = new float[6];
  
  x[0] = 15 * u;
  x[1] = 15 * u;
  x[2] = - 15 * u * sin(PI / 6) + 5 * u * cos(PI / 6);
  x[3] = - 15 * u * sin(PI / 6) - 5 * u * cos(PI / 6);
  x[4] = - 15 * u * sin(PI / 6) - 5 * u * cos(PI / 6);
  x[5] = - 15 * u * sin(PI / 6) + 5 * u * cos(PI / 6);
  
  y[0] = 5 * u;
  y[1] = -5 * u;
  y[2] = - 15 * u * cos(PI / 6) - 5 * u * sin(PI / 6);
  y[3] = - 15 * u * cos(PI / 6) + 5 * u * sin(PI / 6);
  y[4] = 15 * u * cos(PI / 6) - 5 * u * sin(PI / 6);
  y[5] = 15 * u * cos(PI / 6) + 5 * u * sin(PI / 6);
  
  
  beginShape();
  vertex(x[0], y[0], 0);
  vertex(x[1], y[1], 0);
  vertex(x[2], y[2], 0);
  vertex(x[3], y[3], 0);
  vertex(x[4], y[4], 0);
  vertex(x[5], y[5], 0); 
  endShape(CLOSE);
  
  beginShape();
  vertex(x[0], y[0], 3 * u);
  vertex(x[1], y[1], 3 * u);
  vertex(x[2], y[2], 3 * u);
  vertex(x[3], y[3], 3 * u);
  vertex(x[4], y[4], 3 * u);
  vertex(x[5], y[5], 3 * u);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[0], y[0], 0);
  vertex(x[0], y[0], 3 * u);
  vertex(x[1], y[1], 3 * u);
  vertex(x[1], y[1], 0);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[1], y[1], 0);
  vertex(x[1], y[1], 3 * u);
  vertex(x[2], y[2], 3 * u);
  vertex(x[2], y[2], 0);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[2], y[2], 0);
  vertex(x[2], y[2], 3 * u);
  vertex(x[3], y[3], 3 * u);
  vertex(x[3], y[3], 0);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[3], y[3], 0);
  vertex(x[3], y[3], 3 * u);
  vertex(x[4], y[4], 3 * u);
  vertex(x[4], y[4], 0);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[4], y[4], 0);
  vertex(x[4], y[4], 3 * u);
  vertex(x[5], y[5], 3 * u);
  vertex(x[5], y[5], 0);
  endShape(CLOSE);
  
  beginShape();
  vertex(x[5], y[5], 0);
  vertex(x[5], y[5], 3 * u);
  vertex(x[0], y[0], 3 * u);
  vertex(x[0], y[0], 0);
  endShape(CLOSE);
}
