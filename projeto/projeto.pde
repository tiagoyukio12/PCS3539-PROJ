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
  camera(0.0, -250.0, 250.0, 0.0, 0.0, 0.0, 0, -1, 0);
  //rotateY(angle);
  //rotateX(.7);
  lights();
  fill(255);
  noStroke();

  base();
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
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(x[i], y[i], 6 * u);
    drawCylinder(360, 3 * u, 3 * u, 2.5 * u);
    translate(0, 0, 1.25 * u);
    sphere(2 * u);
    popMatrix();
  }
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

void drawCylinder( int sides, float r1, float r2, float h)
{
  float angle = 360 / sides;
  float halfHeight = h / 2;
  // top
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r1;
    float y = sin( radians( i * angle ) ) * r1;
    vertex( x, y, -halfHeight);
  }
  endShape(CLOSE);
  // bottom
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r2;
    float y = sin( radians( i * angle ) ) * r2;
    vertex( x, y, halfHeight);
  }
  endShape(CLOSE);
  // draw body
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x1 = cos( radians( i * angle ) ) * r1;
    float y1 = sin( radians( i * angle ) ) * r1;
    float x2 = cos( radians( i * angle ) ) * r2;
    float y2 = sin( radians( i * angle ) ) * r2;
    vertex( x1, y1, -halfHeight);
    vertex( x2, y2, halfHeight);
  }
  endShape(CLOSE);
} 
