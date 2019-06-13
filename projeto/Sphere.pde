class Sphere {
  float g;
  float[] pos;
  float[] v;
  float[] accel;
  float radius;

  public Sphere(float g, float[] position, float radius) {
    this.g = g;
    pos = position;
    v = new float[3];
    accel = new float[3];
    this.radius = radius;
  }

  public void draw(float[] planePos, float[] planeRotation) {
    pushMatrix();
    rotateZ(planeRotation[2]);
    translate(planePos[0], planePos[1], planePos[2]);
    translate(pos[0], pos[1], pos[2]);
    sphere(radius);
    popMatrix();
  }

  public void updatePosition(float[] planeRotation) {
    updateVelocity(planeRotation); 
    pos[0] += v[0];
    pos[1] += v[1];
    if (v[2] < 0)
      pos[2] += v[2];
    else
      pos[2] = radius + BASE_HEIGHT - pos[0]*sin(planeRotation[1]) - pos[1]*sin(-planeRotation[0]);
  }

  private void updateVelocity(float[] planeRotation) {
    updateAccel(planeRotation);
    v[0] += accel[0];
    v[1] += accel[1];
    if (pow(pos[0], 2) + pow(pos[1], 2) > pow(BASE_RADIUS, 2))
      v[2] -= g;
  }

  private void updateAccel(float[] planeRotation) {
    if (pow(pos[0], 2) + pow(pos[1], 2) <= pow(BASE_RADIUS, 2)) {
      accel[0] = g * sin(planeRotation[1]);
      accel[1] = g * sin(-planeRotation[0]);
    }
  }

  public void drawHUD() {
    String hudPos = String.format("Sphere Relative Position: [%.2f, %.2f,.2f]", pos[0], pos[1], pos[2]);
    ;
    text(hudPos, width * .8, height * .875);
  }
}
