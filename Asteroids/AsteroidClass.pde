class AsteroidClass
{
  float x, y, vx, vy, rad;
  float maxVel = 3, fricion = 0.95;
  float angle = 0, angSpeed;
  int level;
  
  AsteroidClass(float cx, float cy, float cvx, float cvy, int clevel)
  {
    x = cx; y = cy;
    vx = cvx; vy = cvy;
    level = clevel;
    rad = pow(2, level+3);
    angSpeed = random(-0.03, 0.03);
  }
  void destroy()
  {
    float a1 = random(TWO_PI);
    float n = round(random(2, 3));
    float a2 = random(TWO_PI);
    float v = sqrt(random(2));
    for (int j = 0; j < n; j++)
      if (level > 1)
        Asteroids.add(new AsteroidClass(x+rad/2*cos(a1+TWO_PI/n*j), y+rad/2*sin(a1+TWO_PI/n*j), vx+v*cos(a2+TWO_PI/n*j), vy+v*sin(a2+TWO_PI/n*j), level-1));
    shake += level;
    Explosions.add(new ExplosionClass(this.x, this.y, rad*2, rad/7, false));
    Score(level*100);
    asteroidsDestroyed++;
    Asteroids.remove(this);
  }
  void update()
  {
    if (level <= 0)
      Asteroids.remove(this);
      
    angle += angSpeed;
    x += vx; y += vy;
    
    if (sqrt(sq(vx)+sq(vy)) > maxVel)
    {
      vx *= fricion; 
      vy *= fricion;
    }
    
    // Collision detection start
    
    for (int i = 0; i < Asteroids.size(); i++)
    {
      AsteroidClass a = Asteroids.get(i);
      if (dist(x, y, a.x, a.y) <= rad+a.rad && dist(x, y, a.x, a.y) > 0)
      {
        float ang = atan2(a.y-y, a.x-x);
        float dist = dist(x, y, a.x, a.y);
        
        float nx = (a.x-x)/dist, ny = (a.y-y)/dist;
        float tx = -ny, ty = nx;
        
        float dpTan1 = vx*tx + vy*ty;
        float dpTan2 = a.vx*tx + a.vy*ty;
        
        float dpNorm1 = vx*nx + vy*ny;
        float dpNorm2 = a.vx*nx + a.vy*ny;
        
        float m1 = (dpNorm1 * (level - a.level) + 2 * a.level * dpNorm2) / (level + a.level);
        float m2 = (dpNorm2 * (a.level - level) + 2 * level * dpNorm1) / (level + a.level);
        
        vx = 0.7 * tx * dpTan1 + nx * m1;
        vy = 0.7 * ty * dpTan1 + ny * m1;
        a.vx = 0.7 * tx * dpTan2 + nx * m2;
        a.vy = 0.7 * ty * dpTan2 + ny * m2;
        
        x += 0.5*(dist-(rad+a.rad))*cos(ang);
        y += 0.5*(dist-(rad+a.rad))*sin(ang);
        a.x -= 0.5*(dist-(rad+a.rad))*cos(ang);
        a.y -= 0.5*(dist-(rad+a.rad))*sin(ang);
      }
    }
    
    // Collision detection end
    
    if (dist(x, y, 0, 0) > spawnRadius+10)
      Asteroids.remove(this);
      
    for (int i = 0; i < Bullets.size(); i++)
    {
      BulletClass b = Bullets.get(i);
      if (dist(x, y, b.x, b.y) <= rad+b.rad)
      {
        Bullets.remove(i);
        destroy();
      }
    }
    
    for (int i = 0; i < Explosions.size(); i++)
    {
      ExplosionClass e = Explosions.get(i);
      if (dist(x, y, e.x, e.y) <= rad+e.rad && e.destructive == true)
      {
        Explosions.add(new ExplosionClass(this.x, this.y, rad*2, rad/7, false));
        Asteroids.remove(this);
      }
    }
  }
  void display()
  {
    fill(0); stroke(255);
    pushMatrix();
    translate(x*zoom, y*zoom);
    rotate(angle);
    
    beginShape();
    for (int i = 0; i < 6; i++)
      vertex(1.1*rad*cos(TWO_PI/6*i)*zoom, 1.1*rad*sin(TWO_PI/6*i)*zoom);
    endShape(CLOSE);
    
    popMatrix();
  }
}
