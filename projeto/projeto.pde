private final float UNIT = 9;
private final float BASE_RADIUS = 21 * UNIT;
private final float BASE_HEIGHT = 3 * UNIT;
private final float JOINT_OUTER_RADIUS = 3 * UNIT;
private final float JOINT_INNER_RADIUS = 2 * UNIT;
private final float JOINT_HEIGHT = 2.5 * UNIT;

int camMode = 0;

void setup() {
  fullScreen(P3D);
}

void draw() {  
  background(0);

  translate(width/2, height/2);
  
  if (camMode == 0) {
    // Vista estatica
    camera(500, 0, 10 * UNIT, 0.0, 0.0, 0.0, 1, 0, 0);
  } else if (camMode == 1) {
    // Vista dinamica
    camera(60 * UNIT * sin(2 * PI * mouseX / width), 60 * UNIT * cos(2 * PI * mouseX / width), 2.2 * height / 5 - mouseY / 2, 0.0, 0.0, 10 * UNIT, 0, 0, -1);  
  }

  lights();
  fill(255);
  stroke(155);
  
  drawCylinder(BASE_RADIUS, BASE_HEIGHT);
  
  float[] x = new float[6];
  float[] y = new float[6];

  x[0] = 15 * UNIT;
  x[1] = 15 * UNIT;
  x[2] = - 15 * UNIT * sin(PI / 6) + 5 * UNIT * cos(PI / 6);
  x[3] = - 15 * UNIT * sin(PI / 6) - 5 * UNIT * cos(PI / 6);
  x[4] = - 15 * UNIT * sin(PI / 6) - 5 * UNIT * cos(PI / 6);
  x[5] = - 15 * UNIT * sin(PI / 6) + 5 * UNIT * cos(PI / 6);

  y[0] = 5 * UNIT;
  y[1] = -5 * UNIT;
  y[2] = - 15 * UNIT * cos(PI / 6) - 5 * UNIT * sin(PI / 6);
  y[3] = - 15 * UNIT * cos(PI / 6) + 5 * UNIT * sin(PI / 6);
  y[4] = 15 * UNIT * cos(PI / 6) - 5 * UNIT * sin(PI / 6);
  y[5] = 15 * UNIT * cos(PI / 6) + 5 * UNIT * sin(PI / 6);
  
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(x[i], y[i], 3 * UNIT);
    drawCylinder(JOINT_OUTER_RADIUS, JOINT_HEIGHT);
    translate(0, 0, 2 * UNIT);
    noStroke();
    sphere(JOINT_INNER_RADIUS);
    stroke(155);
    popMatrix();
  }
}



void drawCylinder(float r, float h)
{
  int sides = 360;
  float angle = 1;
  // top
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, 0);
  }
  endShape(CLOSE);
  // bottom
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, h);
  }
  endShape(CLOSE);
  // draw body
  noStroke();
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, 0);
    vertex( x, y, h);
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
