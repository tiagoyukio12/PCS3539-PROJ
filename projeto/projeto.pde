import peasy.*;


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

PeasyCam cam;
int camMode = 1;

float[] xJoint = new float[6];
float[] yJoint = new float[6];

float[] upperLegLengths = new float[6];
float[] upperLegIncrement = new float[6];
float[] azimuths = new float[6];
float[] azimuthIncrement = new float[6];
float[] elevations = new float[6];
float[] elevationIncrement = new float[6];

float[] platPos = new float[3];
float[] platPosIncrement = new float[3];
float[] platRot = new float[3];
float[] platRotIncrement = new float[3];

Sphere sphere;

void setup() {
  xJoint[0] = 15 * UNIT;
  xJoint[1] = 15 * UNIT;
  xJoint[2] = - 15 * UNIT * sin(PI / 6) + 5 * UNIT * cos(PI / 6);
  xJoint[3] = - 15 * UNIT * sin(PI / 6) - 5 * UNIT * cos(PI / 6);
  xJoint[4] = - 15 * UNIT * sin(PI / 6) - 5 * UNIT * cos(PI / 6);
  xJoint[5] = - 15 * UNIT * sin(PI / 6) + 5 * UNIT * cos(PI / 6);

  yJoint[0] = 5 * UNIT;
  yJoint[1] = - 5 * UNIT;
  yJoint[2] = - 15 * UNIT * cos(PI / 6) - 5 * UNIT * sin(PI / 6);
  yJoint[3] = - 15 * UNIT * cos(PI / 6) + 5 * UNIT * sin(PI / 6);
  yJoint[4] = 15 * UNIT * cos(PI / 6) - 5 * UNIT * sin(PI / 6);
  yJoint[5] = 15 * UNIT * cos(PI / 6) + 5 * UNIT * sin(PI / 6);

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

  platPos[2] = BASE_HEIGHT + JOINT_HEIGHT / 2 + LOWER_LEG_HEIGHT + upperLegLengths[0];

  float[] initialPos = {0, 0, 225};
  float gravity = 9.8 * UNIT / frameRate;
  float radius = 2.5 * UNIT;
  sphere = new Sphere(gravity, initialPos, radius);

  fullScreen(P3D);

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}


void draw() {
  background(0);

  translate(width/2, height/2);

  if (camMode == 0) {
    // Vista estatica
    camera(500, 0, 10 * UNIT, 0.0, 0.0, 0.0, 1, 0, 0);
  } else if (camMode == 1) {
    // Vista dinamica
    camera(60*UNIT*cos(2*PI*mouseX/width), 60*UNIT*sin(2*PI*mouseX/width - PI), 2.2*height/5 - mouseY/2, 0.0, 0.0, 10*UNIT, 0, 0, -1);
  }

  cam.beginHUD();
  fill(-1);
  String hudPlatPos = String.format("Platform Position: [%.2f, %.2f, %.2f]", platPos[0], platPos[1], platPos[2]);
  text(hudPlatPos, width * .05, height * .875);
  String hudPlatRot =  String.format("Platform Rotation: [%.2f, %.2f, %.2f]", platRot[0], platRot[1], platRot[2]);
  text(hudPlatRot, width * .05, height * .9);

  for (int i = 0; i < 6; i++) {
    String hudLeg = String.format("Piston %d:\n\tLength: %.2f, Azimuth: %.2f, Elevation: %.2f", i + 1, upperLegLengths[i], azimuths[i], elevations[i]);
    text(hudLeg, width * .8, height * .04 * (i + 1));
  }
  String hudCam = "Cam Mode: ";
  if (camMode == 0) {
    fill(255, 0, 0);
    hudCam += "Static";
  } else
    hudCam += "Dynamic";
  text(hudCam, width * .05, height * .04);

  sphere.drawHUD();
  cam.endHUD();

  lights();
  fill(255);
  stroke(155);

  drawCylinder(BASE_RADIUS, BASE_HEIGHT);

  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(xJoint[i], yJoint[i], 3 * UNIT);
    drawCylinder(JOINT_OUTER_RADIUS, JOINT_HEIGHT);
    translate(0, 0, 2 * UNIT);
    noStroke();
    sphere(JOINT_INNER_RADIUS);
    stroke(155);
    popMatrix();
  }

  updateParams();
  drawLegs();
  drawPlatform();

  sphere.updatePosition(platRot);
  sphere.draw(platPos, platRot);
}


// Updates legs and platform position and rotation
void updateParams() {
  platPos[0] += platPosIncrement[0];
  platPos[1] += platPosIncrement[1];
  platPos[2] += platPosIncrement[2];

  platRot[0] += platRotIncrement[0];
  platRot[1] += platRotIncrement[1];
  platRot[2] += platRotIncrement[2];

  // TODO: otimizar codigo
  for (int i = 0; i < 6; i++) {
    PVector p = new PVector(xJoint[i], yJoint[i], 0);
    p = rotate3D(p, platRot[0], 0);
    p = rotate3D(p, platRot[1], 1);
    p = rotate3D(p, platRot[2], 2);
    PVector trans = new PVector(platPos[0], platPos[1], platPos[2]);
    PVector q = p.add(trans);
    PVector b = new PVector(xJoint[i], yJoint[i], 0);
    PVector l = q.sub(b);

    upperLegLengths[i] = l.mag() - LOWER_LEG_HEIGHT - BASE_HEIGHT - JOINT_HEIGHT / 2;  // TODO: checar negativo
    float[] qArr = q.normalize().array();
    azimuths[i] = PI - atan2(qArr[0], qArr[1]);
    elevations[i] = atan2(qArr[2], sqrt(pow(qArr[0], 2) + pow(qArr[1], 2)));
  }
}


// Rotates a vector by an angle [rad] in the given axis
PVector rotate3D(PVector vector, float angle, int axis) {
  PVector ret = vector.copy();
  float[] pos = vector.array();
  PVector vector2D;

  if (axis == 0) {
    vector2D = new PVector(pos[1], pos[2]);
    vector2D.rotate(angle);
    float[] newPos = vector2D.array();
    ret = new PVector(pos[0], newPos[0], newPos[1]);
  } else if (axis == 1) {
    vector2D = new PVector(pos[2], pos[0]);
    vector2D.rotate(angle);
    float[] newPos = vector2D.array();
    ret = new PVector(newPos[1], pos[1], newPos[0]);
  } else if (axis == 2) {
    vector2D = new PVector(pos[0], pos[1]);
    vector2D.rotate(angle);
    float[] newPos = vector2D.array();
    ret = new PVector(newPos[0], newPos[1], pos[2]);
  }
  return ret;
}


// Draws the six Stewart Platform legs
void drawLegs() {
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(xJoint[i], yJoint[i], BASE_HEIGHT + JOINT_INNER_RADIUS);
    rotateZ(azimuths[i]);
    rotateX(PI / 2 - elevations[i]);
    drawCylinder(LOWER_LEG_RADIUS, LOWER_LEG_HEIGHT);
    translate(0, 0, LOWER_LEG_HEIGHT);
    drawCylinder(UPPER_LEG_RADIUS, upperLegLengths[i]);
    popMatrix();
  }
}


void drawPlatform() {
  pushMatrix();
  translate(platPos[0], platPos[1], platPos[2]);
  rotateX(platRot[0]);
  rotateY(platRot[1]);
  rotateZ(platRot[2]);
  drawCylinder(BASE_RADIUS, BASE_HEIGHT);

  // Desenha juncoes
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(xJoint[i], yJoint[i], - 2 * UNIT);
    drawCylinder(JOINT_OUTER_RADIUS, JOINT_HEIGHT);
    noStroke();
    sphere(JOINT_INNER_RADIUS);
    stroke(155);
    popMatrix();
  }
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
  if (key == 'c')
    if (camMode  >= 1)
      camMode = 0;
    else
      camMode++;

  if (key == 'r') {
    float[] initialPos = {0, 0, 225};
    float gravity = 9.8 * UNIT / frameRate;
    float radius = 2.5 * UNIT;
    sphere = new Sphere(gravity, initialPos, radius);
  }

  if (key == 'q') platPosIncrement[2] = LENGTH_INCREMENT;
  if (key == 'e') platPosIncrement[2] = -LENGTH_INCREMENT;
  if (key == 'a') platPosIncrement[1] = LENGTH_INCREMENT;
  if (key == 'd') platPosIncrement[1] = -LENGTH_INCREMENT;
  if (key == 'w') platPosIncrement[0] = LENGTH_INCREMENT;
  if (key == 's') platPosIncrement[0] = -LENGTH_INCREMENT;

  if (key == '1') platRotIncrement[0] = ANGLE_INCREMENT;
  if (key == '2') platRotIncrement[0] = -ANGLE_INCREMENT;
  if (key == '3') platRotIncrement[1] = ANGLE_INCREMENT;
  if (key == '4') platRotIncrement[1] = -ANGLE_INCREMENT;
  if (key == '5') platRotIncrement[2] = ANGLE_INCREMENT;
  if (key == '6') platRotIncrement[2] = -ANGLE_INCREMENT;
}


void keyReleased() {
  if (key == 'w' || key == 's') platPosIncrement[0] = 0;
  if (key == 'a' || key == 'd') platPosIncrement[1] = 0;
  if (key == 'q' || key == 'e') platPosIncrement[2] = 0;

  if (key == '1' || key == '2') platRotIncrement[0] = 0;
  if (key == '3' || key == '4') platRotIncrement[1] = 0;
  if (key == '5' || key == '6') platRotIncrement[2] = 0;
}
