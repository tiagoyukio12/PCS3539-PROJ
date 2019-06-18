import peasy.*; //<>//

PeasyCam cam;

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
private final float POS_INCREMENT = 0.1 * UNIT;
private final float ANGLE_INCREMENT = PI / 360;

float elevacao;
float deslocamento_y;
float deslocamento_x;
float yaw;
float pitch;
float roll;

float del_elevacao;
float del_deslocamento_y;
float del_deslocamento_x;
float del_yaw;
float del_pitch;
float del_roll;

float[] x = new float[6];
float[] y = new float[6];

String mode = "passive";
int retorno = 0;
int camMode = 1;
int legSelect = 0;
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

float[][] rotacaoZ = new float[4][4];
float[][] rotacaoY = new float[4][4];
float[][] rotataoX = new float[4][4];
float[][] translacao = new float[4][4];

Sphere sphere;

void setup() {
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

  calcula_comprimentos();

  elevacao = 30 * UNIT;
  deslocamento_y = 0;
  deslocamento_x = 0;
  yaw = 0;
  pitch = 0;
  roll = 0;

  del_elevacao = 0;
  del_deslocamento_y = 0;
  del_deslocamento_x = 0;
  del_yaw = 0;
  del_pitch = 0;
  del_roll = 0;

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

//void draw() {
//  background(0); // fundo escuro
//  translate(width / 2, height / 2); // centraliza o sistema de coordenadas

//  //
//  // câmera
//  //
//  if (camMode == 0) {
//    // Vista estatica
//    camera(500, 0, 20 * UNIT, 0.0, 0.0, 0.0, 1, 0, 0);
//  } else if (camMode == 1) {
//    // Vista dinamica
//    camera(60 * UNIT * cos(2 * PI * mouseX / width), 60 * UNIT * sin(2 * PI * mouseX / width - PI), 2.2 * height / 5 - mouseY / 2, 0.0, 0.0, 10 * UNIT, 0, 0, -1);  
//  }

//  //
//  // plota a posição da plataforma
//  //
//  cam.beginHUD();
//  fill(-1);
//  String hudPlatPos = String.format("Platform Position: [%.2f, %.2f, %.2f]", platPos[0], platPos[1], platPos[2]);
//  text(hudPlatPos, width * .05, height * .875);
//  String hudPlatRot =  String.format("Platform Rotation: [%.2f, %.2f, %.2f]", platRot[0], platRot[1], platRot[2]);
//  text(hudPlatRot, width * .05, height * .9);

//}

void draw() {
  background(0);

  translate(width/2, height/2);

  if (camMode == 0) {
    // Vista estatica
    camera(500, 0, 30 * UNIT, 0.0, 0.0, 20 * UNIT, 1, 0, 0);
  } else if (camMode == 1) {
    // Vista dinamica
    camera(60 * UNIT * cos(2 * PI * mouseX / width), 60 * UNIT * sin(2 * PI * mouseX / width - PI), 2.2 * height / 5 - mouseY / 2, 0.0, 0.0, 10 * UNIT, 0, 0, -1);
  }

  calcula_comprimentos();

  cam.beginHUD();
  fill(-1);
  String texto = String.format("Plataform Position:\n");
  text(texto, width * 0.05, height * 0.8);
  texto = String.format("     Center: (%.2f, %.2f, %.2f)\n", deslocamento_x, deslocamento_y, elevacao);
  text(texto, width * .05, height * 0.825);
  texto =  String.format("     Roll angle: %.2f rad", roll);
  text(texto, width * .05, height * 0.85);
  texto =  String.format("     Pitch angle: %.2f rad", pitch);
  text(texto, width * .05, height * 0.875);
  texto =  String.format("     Yaw angle: %.2f rad", yaw);
  text(texto, width * .05, height * 0.9);

  texto = String.format("Length of Pistons:\n");
  text(texto, width * 0.8, height * 0.75);
  for (int i = 0; i < 6; i++) {
    texto = String.format("     Piston %d:   %.2f", i + 1, upperLegLengths[i]);
    text(texto, width * .8, height * (0.75 + 0.025 * (i + 1)));
  }

  String hudCam = "Cam Mode: ";
  if (camMode == 0) {
    fill(255, 0, 0);
    hudCam += "Static";
  } else
    hudCam += "Dynamic";
  text(hudCam, width * .05, height * .04);
  cam.endHUD();

  lights();
  fill(255);
  stroke(155);


  // MECANISMO

  drawCylinder(BASE_RADIUS, BASE_HEIGHT);

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

  if (retorno == 0) {
    boolean movimenta = true;
    for (int i = 0; i < 6; i ++) if (upperLegLengths[i] < 15 * UNIT || upperLegLengths[i] > 30 * UNIT) movimenta = false;
    if (movimenta) {
      elevacao = elevacao + del_elevacao;
      deslocamento_y = deslocamento_y + del_deslocamento_y;
      deslocamento_x = deslocamento_x + del_deslocamento_x;
      yaw = yaw + del_yaw;
      pitch = pitch + del_pitch;
      roll = roll + del_roll;
    }
  } else {
    if (elevacao > 30 * UNIT + 0.5 * POS_INCREMENT) elevacao = elevacao - POS_INCREMENT;
    else if (elevacao < 30 * UNIT - 0.5 * POS_INCREMENT) elevacao = elevacao + POS_INCREMENT;
    else if (deslocamento_x > 0.5 * POS_INCREMENT) deslocamento_x = deslocamento_x - POS_INCREMENT;
    else if (deslocamento_x < -0.5 * POS_INCREMENT) deslocamento_x = deslocamento_x + POS_INCREMENT;
    else if (deslocamento_y > 0.5 * POS_INCREMENT) deslocamento_y = deslocamento_y - POS_INCREMENT;
    else if (deslocamento_y < -0.5 * POS_INCREMENT) deslocamento_y = deslocamento_y + POS_INCREMENT;
    else if (roll > 0.5 * ANGLE_INCREMENT) roll = roll - ANGLE_INCREMENT;
    else if (roll < -0.5 * ANGLE_INCREMENT) roll = roll + ANGLE_INCREMENT;
    else if (pitch > 0.5 * ANGLE_INCREMENT) pitch = pitch - ANGLE_INCREMENT;
    else if (pitch < -0.5 * ANGLE_INCREMENT) pitch = pitch + ANGLE_INCREMENT;
    else if (yaw > 0.5 * ANGLE_INCREMENT) yaw = yaw - ANGLE_INCREMENT;
    else if (yaw < -0.5 * ANGLE_INCREMENT) yaw = yaw + ANGLE_INCREMENT;
  }

  pushMatrix();
  translate(deslocamento_x, deslocamento_y, elevacao);
  rotateX(roll);
  rotateY(pitch);
  rotateZ(yaw);

  drawCylinder(BASE_RADIUS, BASE_HEIGHT);

  rotateZ(PI / 3);
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(x[i], y[i], - 2 * UNIT);
    drawCylinder(JOINT_OUTER_RADIUS, JOINT_HEIGHT);
    noStroke();
    sphere(JOINT_INNER_RADIUS);
    stroke(155);
    popMatrix();
  }
  popMatrix();

  pistao();
  float[] platPos = {deslocamento_x, deslocamento_y, elevacao};
  float[] platRot = {roll, pitch, yaw};
  sphere.updatePosition(platRot);
  sphere.draw(platPos, platRot);
}

void calcula_comprimentos() {
  for (int i = 0; i < 6; i ++) {
    float x_i = x[i % 6];
    float y_i = y[i % 6];
    float z_i = 5 * UNIT;
    float x_f = x[(i + 1) % 6];
    float y_f = y[(i + 1) % 6];
    float z_f = -2 * UNIT;
    float x_t = movimenta_coordenada(0, x_i, y_i, z_i);
    float y_t = movimenta_coordenada(1, x_i, y_i, z_i);
    float z_t = movimenta_coordenada(2, x_i, y_i, z_i);
    x_i = x_t;
    y_i = y_t;
    z_i = z_t;
    upperLegLengths[i] = sqrt((x_f - x_i) * (x_f - x_i) + (y_f - y_i) * (y_f - y_i) + (z_f - z_i) * (z_f - z_i));
  }
}

void updateParams(float[] x, float[] y) {
  if (mode.equals("active")) {
    if (upperLegLengths[legSelect] + upperLegIncrement[legSelect] >= 0)
      upperLegLengths[legSelect] += upperLegIncrement[legSelect];

    azimuths[legSelect] += azimuthIncrement[legSelect];

    elevations[legSelect] += elevationIncrement[legSelect];

    // TODO: Update other leg angles
  } else if (mode.equals("passive")) {
    platPos[0] += platPosIncrement[0];
    platPos[1] += platPosIncrement[1];
    platPos[2] += platPosIncrement[2];

    platRot[0] += platRotIncrement[0];
    platRot[1] += platRotIncrement[1];
    platRot[2] += platRotIncrement[2];

    // TODO: otimizar codigo
    for (int i = 0; i < 6; i++) {
      PVector p = new PVector(x[i], y[i], 0);
      p = rotate3D(p, platRot[0], 0);
      p = rotate3D(p, platRot[1], 1);
      p = rotate3D(p, platRot[2], 2);
      PVector trans = new PVector(platPos[0], platPos[1], platPos[2]);
      PVector q = p.add(trans);
      PVector b = new PVector(x[i], y[i], 0);
      PVector l = q.sub(b);

      upperLegLengths[i] = l.mag() - LOWER_LEG_HEIGHT - BASE_HEIGHT - JOINT_HEIGHT / 2;  // TODO: checar negativo
      float[] qArr = q.normalize().array();
      azimuths[i] = PI - atan2(qArr[0], qArr[1]);
      elevations[i] = atan2(qArr[2], sqrt(pow(qArr[0], 2) + pow(qArr[1], 2)));
    }
  }
}

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

void drawLegs(float[] x, float[] y) {
  for (int i = 0; i < 6; i++) {
    drawLeg(upperLegLengths[i], x[i], y[i], azimuths[i], elevations[i]);
  }
}

void drawLeg(float upperLegLength, float x, float y, float azimuth, float elevation) {
  pushMatrix();
  translate(x, y, BASE_HEIGHT + JOINT_INNER_RADIUS);
  rotateZ(azimuth);
  rotateX(PI / 2 - elevation);
  drawCylinder(LOWER_LEG_RADIUS, LOWER_LEG_HEIGHT);
  translate(0, 0, LOWER_LEG_HEIGHT);
  drawCylinder(UPPER_LEG_RADIUS, upperLegLength);
  popMatrix();
}

void drawPlatform() {
  pushMatrix();
  rotateX(platRot[0]);
  rotateY(platRot[1]);
  rotateZ(platRot[2]);
  translate(platPos[0], platPos[1], platPos[2]);
  drawCylinder(BASE_RADIUS, BASE_HEIGHT);
  for (int i = 0; i < 6; i++) {
    pushMatrix();
    translate(x[i], y[i], - 2 * UNIT);
    drawCylinder(JOINT_OUTER_RADIUS, JOINT_HEIGHT);
    //translate(0, 0, - 2 * UNIT);
    noStroke();
    sphere(JOINT_INNER_RADIUS);
    stroke(155);
    popMatrix();
  }
  popMatrix();
}

void pistao() {
  for (int j = 0; j < 6; j ++) {
    pushMatrix();
    translate(deslocamento_x, deslocamento_y, elevacao);
    rotateX(roll);
    rotateY(pitch);
    rotateZ(yaw + PI / 3);
    noStroke();
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < 361; i++) {
      float x_i = x[j % 6] + cos(radians(i) + yaw + PI/3) * 0.5 * JOINT_INNER_RADIUS;
      float y_i = y[j % 6] + sin(radians(i) + yaw + PI/3) * 0.5 * JOINT_INNER_RADIUS;
      float z_i = 5 * UNIT;
      float x_f = x[(j + 1) % 6] + cos(radians(i)) * 0.5 * JOINT_INNER_RADIUS;
      float y_f = y[(j + 1) % 6] + sin(radians(i)) * 0.5 * JOINT_INNER_RADIUS;
      float z_f = - 2 * UNIT;
      float x_t = movimenta_coordenada(0, x_i, y_i, z_i);
      float y_t = movimenta_coordenada(1, x_i, y_i, z_i);
      float z_t = movimenta_coordenada(2, x_i, y_i, z_i);
      x_i = x_t;
      y_i = y_t;
      z_i = z_t;
      vertex(x_i, y_i, z_i);
      vertex(x_f, y_f, z_f);
    }
    endShape(CLOSE);
    stroke(155);
    popMatrix();
    // capa do pistão
    pushMatrix();
    float[] pontos_x = new float[360];
    float[] pontos_y = new float[360];
    float[] pontos_z = new float[360];
    translate(deslocamento_x, deslocamento_y, elevacao);
    rotateX(roll);
    rotateY(pitch);
    rotateZ(yaw + PI / 3);
    noStroke();
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < 361; i++) {
      float x_i = x[j % 6] + cos(radians(i) + yaw + PI/3) * 0.7 * JOINT_INNER_RADIUS;
      float y_i = y[j % 6] + sin(radians(i) + yaw + PI/3) * 0.7 * JOINT_INNER_RADIUS;
      float z_i = 5 * UNIT;
      float x_f = x[(j + 1) % 6] + cos(radians(i)) * 0.7 * JOINT_INNER_RADIUS;
      float y_f = y[(j + 1) % 6] + sin(radians(i)) * 0.7 * JOINT_INNER_RADIUS;
      float z_f = - 2 * UNIT;
      float x_t = movimenta_coordenada(0, x_i, y_i, z_i);
      float y_t = movimenta_coordenada(1, x_i, y_i, z_i);
      float z_t = movimenta_coordenada(2, x_i, y_i, z_i);
      x_i = x_t;
      y_i = y_t;
      z_i = z_t;
      float x_m = x_i + (15 * UNIT / upperLegLengths[j]) * (x_f - x_i);
      float y_m = y_i + (15 * UNIT / upperLegLengths[j]) * (y_f - y_i);
      float z_m = z_i + (15 * UNIT / upperLegLengths[j]) * (z_f - z_i);
      pontos_x[i % 360] = x_m;
      pontos_y[i % 360] = y_m;
      pontos_z[i % 360] = z_m;
      vertex(x_i, y_i, z_i);
      vertex(x_m, y_m, z_m);
    }
    endShape(CLOSE);
    stroke(155);
    beginShape();
    for (int i = 0; i < 360; i ++) {
      vertex(pontos_x[i], pontos_y[i], pontos_z[i]);
    }
    endShape(CLOSE);
    popMatrix();
  }
}

void drawCylinder(float r, float h)
{
  int sides = 360;
  float angle = 1;
  // bottom
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, 0);
  }
  endShape(CLOSE);
  // top
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

///
//// coordenada seleciona a coordenada desejada
// 0 - x
// 1 - y
// 2 - z
///
float movimenta_coordenada(int coordenada, float x, float y, float z) {
  float r = - 30 * UNIT;

  float x_r = x - deslocamento_x;
  float y_r = y - deslocamento_y;
  float z_r = z - elevacao;

  float x_t = x_r;
  float y_t = y_r;
  float z_t = z_r;

  y_t = y_r * cos(-roll) - z_r * sin(-roll);
  z_t = y_r * sin(-roll) + z_r * cos(-roll);
  y_r = y_t;
  z_r = z_t;

  x_t = x_r * cos(-pitch) + z_r * sin(-pitch);
  z_t = - x_r * sin(-pitch) + z_r * cos(-pitch);
  x_r = x_t;
  z_r = z_t;

  x_t = x_r * cos(-yaw - PI / 3) - y_r * sin(-yaw - PI / 3);
  y_t = x_r * sin(-yaw - PI / 3) + y_r * cos(-yaw - PI / 3);
  x_r = x_t;
  y_r = y_t;

  if (coordenada == 0) r = x_r;
  else if (coordenada == 1) r = y_r;
  else if (coordenada == 2) r = z_r;

  return r;
}

void keyPressed() {

  // ajuste da câmera
  if (key == 'c') {
    if (camMode  >= 1)
      camMode = 0;
    else
      camMode++;
  }

  // modo de funcionamento da plataforma
  if (key == 'm') {
    if (mode.equals("passive"))
      mode = "active";
    else
      mode = "passive";
  }

  // modo retorno do movimento
  if (key == 'r') retorno = 1;  

  if (mode.equals("active")) {
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
  } else if (mode.equals("passive")) {
    if (key == 'w') {
      del_elevacao = POS_INCREMENT;
    }
    if (key == 's') {
      del_elevacao = -POS_INCREMENT;
    }
    if (key == 'a') {
      del_deslocamento_x = -POS_INCREMENT;
    }
    if (key == 'd') {
      del_deslocamento_x = POS_INCREMENT;
    }
    if (key == 'q') {
      del_deslocamento_y = -POS_INCREMENT;
    }
    if (key == 'e') {
      del_deslocamento_y = POS_INCREMENT;
    }

    if (key == '1') {
      del_yaw = -ANGLE_INCREMENT;
    }
    if (key == '2') {
      del_yaw = ANGLE_INCREMENT;
    }
    if (key == '3') {
      del_pitch = -ANGLE_INCREMENT;
    }
    if (key == '4') {
      del_pitch = ANGLE_INCREMENT;
    }
    if (key == '5') {
      del_roll = -ANGLE_INCREMENT;
    }
    if (key == '6') {
      del_roll = ANGLE_INCREMENT;
    }

    if (key == 'z') {
      float[] initialPos = {0, 0, 225};
      float gravity = 9.8 * UNIT / frameRate;
      float radius = 2.5 * UNIT;
      sphere = new Sphere(gravity, initialPos, radius);
    }
  }
}

void keyReleased() {
  if (key == 'w' || key == 's') del_elevacao = 0;
  if (key == 'a' || key == 'd') del_deslocamento_x = 0;
  if (key == 'q' || key == 'e') del_deslocamento_y = 0;
  if (key == '1' || key == '2') del_yaw = 0;
  if (key == '3' || key == '4') del_pitch = 0;
  if (key == '5' || key == '6') del_roll = 0;

  // modo retorno do movimento
  if (key == 'r') retorno = 0;
}
