private final float UNIT = 9;
private final float BASE_RADIUS = 21 * UNIT;
private final float BASE_HEIGHT = 3 * UNIT;
private final float JOINT_OUTER_RADIUS = 3 * UNIT;
private final float JOINT_INNER_RADIUS = 2 * UNIT;
private final float JOINT_HEIGHT = 2.5 * UNIT;
private final float LOWER_LEG_RADIUS = 1.5 * UNIT;
private final float LOWER_LEG_HEIGHT = 10 * UNIT;
private final float UPPER_LEG_RADIUS = 1 * UNIT;
private final float LENGTH_INCREMENT = 0.5 * UNIT;
private final float ANGLE_INCREMENT = PI / 360;

int camMode = 0;
int legSelect = 0;
float[] upperLegLengths = new float[6];
float[] upperLegIncrement = new float[6];
float[] azimuths = new float[6];
float[] azimuthIncrement = new float[6];
float[] elevations = new float[6];
float[] elevationIncrement = new float[6];

void setup() {
  upperLegLengths[0] = 5 * UNIT;
  upperLegLengths[1] = 5 * UNIT;
  upperLegLengths[2] = 5 * UNIT;
  upperLegLengths[3] = 5 * UNIT;
  upperLegLengths[4] = 5 * UNIT;
  upperLegLengths[5] = 5 * UNIT;
    
  azimuths[0] = 0;
  azimuths[1] = 0;
  azimuths[2] = 0;
  azimuths[3] = 0;
  azimuths[4] = 0;
  azimuths[5] = 0;
  
  elevations[0] = PI / 2;
  elevations[1] = PI / 2;
  elevations[2] = PI / 2;
  elevations[3] = PI / 2;
  elevations[4] = PI / 2;
  elevations[5] = PI / 2;
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
  
  updateLegs();
  drawLegs(x, y);
}

void updateLegs() {
  if (upperLegLengths[legSelect] + upperLegIncrement[legSelect] >= 0)
    upperLegLengths[legSelect] += upperLegIncrement[legSelect];
  
  azimuths[legSelect] += azimuthIncrement[legSelect];
  
  elevations[legSelect] += elevationIncrement[legSelect];
  
  // TODO: Update other leg angles
}

void drawLegs(float[] x, float[] y) {
  for (int i = 0; i < 6; i++) {
    drawLeg(upperLegLengths[i], x[i], y[i], azimuths[i], elevations[i]);
  }
}

void drawLeg(float upperLegLength, float x, float y, float azimuth, float elevation) {
  pushMatrix();
  translate(x, y, 3 * UNIT + JOINT_INNER_RADIUS);
  rotateZ(azimuth);
  rotateX(PI / 2 - elevation);
  drawCylinder(LOWER_LEG_RADIUS, LOWER_LEG_HEIGHT);
  translate(0, 0, LOWER_LEG_HEIGHT);
  drawCylinder(UPPER_LEG_RADIUS, upperLegLength);
  popMatrix();
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
  if (key == 'c') {
    if (camMode  >= 1)
      camMode = 0;
    else
      camMode++;
  }
  
  if (key == '1')
    legSelect = 0;
  if (key == '2')
    legSelect = 1;
  if (key == '3')
    legSelect = 2;  
  if (key == '4')
    legSelect = 3;
  if (key == '5')
    legSelect = 4;
  if (key == '6')
    legSelect = 5;
  
  if (key == 'q') {
    upperLegIncrement[legSelect] = LENGTH_INCREMENT;
  }
  if (key == 'e') {
    upperLegIncrement[legSelect] = -LENGTH_INCREMENT;
  }
  
  if (key == 'a') {
    azimuthIncrement[legSelect] = 2 * ANGLE_INCREMENT;
  }
  if (key == 'd') {
    azimuthIncrement[legSelect] = -2 * ANGLE_INCREMENT;
  }
  
  if (key == 'w') {
    elevationIncrement[legSelect] = ANGLE_INCREMENT;
  }
  if (key == 's') {
    elevationIncrement[legSelect] = -ANGLE_INCREMENT;
  }
}

void keyReleased() {
    if (key == 'q' || key == 'e')
      upperLegIncrement[legSelect] = 0;
    if (key == 'a' || key == 'd')
      azimuthIncrement[legSelect] = 0;
    if (key == 'w' || key == 's')
      elevationIncrement[legSelect] = 0;
}
