class CatalystClass
{
  float x, y, rad;
  float timer = 150;
  boolean exploded = false;
  CatalystClass(float cx, float cy, float crad)
  {
    x = cx; y = cy; rad = crad;
  }
  void update()
  {
    if (!exploded)
      timer --;
    else
      timer += 3;
    if (timer <= 0)
    {
      timer = 0;
      exploded = true;
      Explosions.add(new ExplosionClass(x, y, rad, 25, true));
      shake += 300;
    }
    if (exploded && timer >= 120)
      Catalysts.remove(this);
  }
  void display()
  {
    fill(255, 20*(1-timer/120)); stroke(255*(1-timer/120));
    ellipse(x*zoom, y*zoom, rad*2*zoom, rad*2*zoom);
    
    if (!exploded)
    {
      fill(255, 20*(1-timer/120)); noStroke();
      ellipse(x*zoom, y*zoom, (1-timer/120)*rad*2*zoom, (1-timer/120)*rad*2*zoom);
    }
    
    textSize(rad/2);
    fill(255);
  }
}
