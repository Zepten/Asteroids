class BulletClass
{
  float x, y, angle;
  float speed = 15;
  float rad = 5;
  BulletClass(float cx, float cy, float cangle)
  {
    x = cx; y = cy; angle = cangle;
  }
  void update()
  {
    x += speed*cos(angle);
    y += speed*sin(angle);
    
    for (int i = 0; i < 1; i++)
    {
      Particles.add(new ParticleClass(x-35*cos(angle), y-35*sin(angle), random(0, 5), PI+angle+random(-0.1, 0.1), random(5, 20)));
    }
    
    if (x < (-width/2-10)/zoom || x > (width/2+10)/zoom || y < (-height/2-10)/zoom || y > (height/2+10)/zoom)
      Bullets.remove(this);
  }
  void display()
  {
    fill(255); noStroke();
    pushMatrix();
    translate(x*zoom, y*zoom);
    rotate(angle);
    beginShape();
    vertex(-10*zoom, -5*zoom);
    vertex(10*zoom, 0);
    vertex(-10*zoom, 5*zoom);
    endShape(CLOSE);
    popMatrix();
  }
}
