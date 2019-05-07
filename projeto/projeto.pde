PShape can;
float angle;
PShader colorShader;

void setup() {
  fullScreen(P3D);
  //can = createCan(100, 200, 32);
}

void draw() {
  float u = height / 100;
  
  background(0);

  translate(width/2, height/2);
  camera(0.0, -550.0, 20.0, 0.0, 0.0, 0.0, 0, -1, 0);
  lights();
  fill(255);
  noStroke();
  
  drawCylinder(360, 21 * u, 21 * u, 3 * u);
  
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
    translate(x[i], y[i], 3 * u);
    drawCylinder(360, 3 * u, 3 * u, 2.5 * u);
    translate(0, 0, 2 * u);
    sphere(2 * u);
    
    popMatrix();
  }
}



void drawCylinder( int sides, float r1, float r2, float h)
{
  float angle = 360 / sides;
  // top
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r1;
    float y = sin( radians( i * angle ) ) * r1;
    vertex( x, y, 0);
  }
  endShape(CLOSE);
  // bottom
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r2;
    float y = sin( radians( i * angle ) ) * r2;
    vertex( x, y, h);
  }
  endShape(CLOSE);
  // draw body
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x1 = cos( radians( i * angle ) ) * r1;
    float y1 = sin( radians( i * angle ) ) * r1;
    float x2 = cos( radians( i * angle ) ) * r2;
    float y2 = sin( radians( i * angle ) ) * r2;
    vertex( x1, y1, 0);
    vertex( x2, y2, h);
  }
  endShape(CLOSE);
} 
