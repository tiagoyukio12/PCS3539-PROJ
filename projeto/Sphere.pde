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
      pos[2] = radius + BASE_HEIGHT - pos[0]*sin(planeRotation[1]) - pos[1]*sin(-planeRotation[0]);
  }
  
  private void updateVelocity(float[] planeRotation) {
    updateAccel(planeRotation);
    v[0] += accel[0];
    v[1] += accel[1];
    
    if (pow(pos[0], 2) + pow(pos[1], 2) > 190 * 190) {
      if (v[0] * pos[0] >= 0)
        v[0] = 0;
      if (v[1] * pos[1] >= 0)
        v[1] = 0;
    }
  }
  
  private void updateAccel(float[] planeRotation) {
    accel[0] = g * sin(planeRotation[1]);
    accel[1] = g * sin(-planeRotation[0]);
  }
}
