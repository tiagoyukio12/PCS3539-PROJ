class Sphere {
  float[] pos;
  float[] v;
  float[] accel;
  float radius;
  
  public Sphere(float[] position, float radius) {
    pos = position;
    v = new float[3];
    accel = new float[3];
    this.radius = radius;
  }
  
  public void draw() {
    pushMatrix();
    translate(pos[0], pos[1], pos[2]);
    sphere(radius);
    popMatrix();
  }
  
  public void updatePosition(float[] planeRotation) {
    updateVelocity(planeRotation);
    pos[0] += v[0];
  }
  
  private void updateVelocity(float[] planeRotation) {
    updateAccel(planeRotation);
    v[0] += accel[0];
  }
  
  private void updateAccel(float[] planeRotation) {
    accel[0] = cos(planeRotation[1]);
  }
}
