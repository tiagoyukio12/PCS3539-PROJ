import peasy.*;

int camMode = 0;

void setup() {
  fullScreen(P3D);
}

void draw() {
  float u = height / 100;
  
  background(0);

  translate(width/2, height/2);
  
  if (camMode == 0) {
    // Vista estatica
    camera(500, 0, 10 * u, 0.0, 0.0, 0.0, 1, 0, 0);
  } else if (camMode == 1) {
    // Vista dinamica
    camera(60 * u * sin(2 * PI * mouseX / width), 60 * u * cos(2 * PI * mouseX / width), 2.2 * height / 5 - mouseY / 2, 0.0, 0.0, 10 * u, 0, 0, -1);  
  }

  lights();
  fill(255);
  stroke(155);
  
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
    noStroke();
    sphere(2 * u);
    stroke(155);
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
  noStroke();
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
  stroke(155);
}

void keyPressed() {
  if (key == '1') {
    if (camMode  >= 1)
      camMode = 0;
    else
      camMode++;
  }
}
