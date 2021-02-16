class PlayerClass
{
  float x, y;
  float angle = 0, vx = 0, vy = 0;
  float maxVel = 5;
  boolean thrusting, rotatingRight, rotatingLeft, invincible, onShot;
  float thrust = 0.2;
  float angVel = 0.07;
  float friction = 0.99;
  float maxShootDelay = 25, shootDelay = maxShootDelay;
  float colRad = 14;
  float t = 0;
  float maxInvTime = 180, invTime = maxInvTime;
  
  PlayerClass(float cx, float cy)
  {
    x = cx; y = cy;
  }
  void update()
  {
    if (invincible)
    {
      invTime--;
      if (invTime <= 0)
      {
        invTime = maxInvTime;
        invincible = false;
      }
    }
    
    if (!dead && !invincible)
    {
      for (int i = 0; i < Asteroids.size(); i++)
      {
        AsteroidClass a = Asteroids.get(i);
        if (dist(x, y, a.x, a.y) <= colRad+a.rad)
        {
          float an = random(TWO_PI);
          a.vx = 0.5*vx/a.level+cos(an);
          a.vy = 0.5*vy/a.level+sin(an);
          death();
        }
      }
      for (int i = 0; i < Explosions.size(); i++)
      {
        ExplosionClass e = Explosions.get(i);
        if (dist(x, y, e.x, e.y) <= colRad+e.rad && e.destructive == true)
        {
          death();
        }
      }
    }
    
    if (thrusting)
    {
      vx += thrust*cos(angle);
      vy += thrust*sin(angle);
    }
    else
    {
      vx *= friction;
      vy *= friction;
    }
    
    float vel = sqrt(sq(vx)+sq(vy));
    float nvx = vx/vel, nvy = vy/vel;
      
    if (vel > maxVel)
    {
      vx = maxVel*nvx;
      vy = maxVel*nvy;
    }
    
    if (rotatingRight)
      angle += angVel;
      
    if (rotatingLeft)
      angle -= angVel;
      
    if (angle < 0)
      angle = TWO_PI-angle;
    else
    if (angle > TWO_PI)
      angle = angle-TWO_PI;
    
    x += vx; y += vy;
    
    if (x > width/2/zoom) {x = width/2/zoom; vx = 0;}
    else if (x < -width/2/zoom) {x = -width/2/zoom; vx = 0;}
      
    if (y > height/2/zoom) {y = height/2/zoom; vy = 0;}
    else if (y < -height/2/zoom) {y = -height/2/zoom; vy = 0;}
    
    shootDelay--;
    t += 0.2;
    if (shootDelay <= 0 && onShot && !dead) shot(1);
  }
  void shot(int type)
  {
    switch(type){
      case 0:{
        shootDelay = maxShootDelay;
        Bullets.add(new BulletClass(Player.x+20*cos(Player.angle), Player.y+20*sin(Player.angle), Player.angle));
        //shot_sound.play();
        //shot_sound.amp(0.5);
      }
      case 1:{
        shootDelay = maxShootDelay;
        for (int i = -2; i <= 2; i++)
          Bullets.add(new BulletClass(Player.x+20*cos(Player.angle), Player.y+20*sin(Player.angle), Player.angle + i * 0.12));
        //shot_sound.play();
        //shot_sound.amp(0.5);
      }
    }
  }
  void display()
  {
    fill(0);
    if (!invincible)
      stroke(255);
    else
      stroke(255, 150+100*sin(0.3*frameCount));
    pushMatrix();
    translate(x*zoom, y*zoom);
    rotate(angle);
    beginShape();
    vertex(-10*zoom, -10*zoom);
    vertex(20*zoom, 0*zoom);
    vertex(-10*zoom, 10*zoom);
    vertex(-5*zoom, 0*zoom);
    endShape(CLOSE);
    translate(-15*zoom, 0*zoom);
    if (thrusting)
    {
      if (t >= 1.5)
        t = 0;
      stroke(255); noFill();
      beginShape();
      vertex(-2*t*zoom, -5*t*zoom);
      vertex(3*t*zoom, 0*t*zoom);
      vertex(-2*t*zoom, 5*t*zoom);
      vertex(-20*t*zoom, 0*zoom);
      endShape(CLOSE);
    }
    popMatrix();
  }
}
