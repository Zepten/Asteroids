class ParticleClass
{
  float x, y, vel, a, t;
  float maxT;
  float l = 25;
  ParticleClass(float cx, float cy, float cvel, float ca, float ct)
  {
    x = cx; y = cy; vel = cvel; a = ca; t = ct;
    maxT = t;
  }
  void update()
  {
    x += vel*cos(a);
    y += vel*sin(a);
    t -= 1;
    if (t <= 0)
      Particles.remove(this);
  }
  void display()
  {
    stroke(255, 255*t/maxT);
    pushMatrix();
    translate(x*zoom, y*zoom);
    rotate(a);
    line(0, 0, -l*t/maxT, 0);
    popMatrix();
  }
}
