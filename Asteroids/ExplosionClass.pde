class ExplosionClass
{
  float x, y, maxr, speed;
  float rad = 0;
  boolean destructive;
  ExplosionClass(float cx, float cy, float cmaxr, float cspeed, boolean cdestructive)
  {
    x = cx; y = cy; maxr = cmaxr; speed = cspeed;
    destructive = cdestructive;
    for (int i = 0; i < 10; i++)
    {
      Particles.add(new ParticleClass(x, y, random(0, 5), random(TWO_PI), random(10, 40)));
    }
    /*if (destructive){
      explosion_big_sound.play();
      explosion_big_sound.rate(random(0.85, 1.25));
    }
    else{
      explosion_small_sound.play();
    }*/
  }
  void update()
  {
    rad += speed;
    if (rad > maxr)
    {
      Explosions.remove(this);
    }
  }
  void display()
  {
    noStroke(); fill(255, 255*(1-rad/maxr));
    ellipse(x*zoom, y*zoom, rad*2*zoom, rad*2*zoom);
  }
}
