import processing.sound.*;

/*SoundFile collision_sound;
SoundFile death_sound;
SoundFile explosion_big_sound;
SoundFile explosion_small_sound;
SoundFile game_over_sound;
SoundFile music;
SoundFile respawn_sound;
SoundFile shot_sound;

void loadSounds(){
  collision_sound = new SoundFile(this, "Sounds/collision.mp3");
  death_sound = new SoundFile(this, "Sounds/death.mp3");
  explosion_big_sound = new SoundFile(this, "Sounds/explosion_big.mp3");
  explosion_small_sound = new SoundFile(this, "Sounds/explosion_small.mp3");
  game_over_sound = new SoundFile(this, "Sounds/game_over.mp3");
  music = new SoundFile(this, "Sounds/music.mp3");
  respawn_sound = new SoundFile(this, "Sounds/respawn.mp3");
  shot_sound = new SoundFile(this, "Sounds/shot.mp3");
}*/

PlayerClass Player;
ArrayList<AsteroidClass> Asteroids;
ArrayList<BulletClass> Bullets;
ArrayList<ExplosionClass> Explosions;
ArrayList<CatalystClass> Catalysts;
ArrayList<ParticleClass> Particles;

int
KEY_SHOOT = 10,
KEY_THRUST = 87,
KEY_LEFT = 65,
KEY_RIGHT = 68;

int MaxScore;
int Score;
int Lives, maxLives = 3;
int AsteroidTimer;
int CatalystTimer;

float spawnRadius = 1200;
float zoom;
float camX = 0, camY = 0, shake = 0;
float CurrentScoreSize, ScoreSize = 40;

boolean begin = true, beginWait, dead, gameOver, restarting;
int deathClock, maxDeathClock = 180, asteroidsDestroyed;
int ignoreEnterTime, beginTimer = 0;
float time;

int scoreByLife, lifeScore, scoreByLifeInc = 5000;
float lifeScoreLerp;
boolean lifeReady;
boolean lifeReadyExplode;

float backFlash;

void restart()
{
  CurrentScoreSize = ScoreSize;
  lifeReady = false;
  lifeReadyExplode = false;
  lifeScore = 0;
  lifeScoreLerp = 0;
  scoreByLife = 5000;
  ignoreEnterTime = 120;
  restarting = false;
  backFlash = 255;
  gameOver = false;
  dead = false;
  asteroidsDestroyed = 0;
  Score = 0;
  time = 0;
  AsteroidTimer = 0;
  CatalystTimer = 1200;
  Lives = maxLives;
  Particles.clear();
  Explosions.clear();
  Asteroids.clear();
  Bullets.clear();
  Catalysts.clear();
  Player.x = 0; Player.y = 0; 
  Player.vx = 0; Player.vy = 0; 
  Player.angle = 0;
  Player.thrusting = false; 
  Player.rotatingRight = false; 
  Player.rotatingLeft = false;
  /*respawn_sound.play();
  if (!music.isPlaying())
    music.play();*/
}

void Score(int n)
{
  if (!dead && !gameOver)
  {
    Score += n;
    lifeScore += n;
    CurrentScoreSize = ScoreSize+10;
  }
  
  if (lifeScore >= scoreByLife)
  {
    lifeReady = true;
    lifeScore = scoreByLife;
    if (!lifeReadyExplode)
    {
      Explosions.add(new ExplosionClass((45-width/2)/zoom, (50-height/2)/zoom, 200/zoom, 5, false));
      lifeReadyExplode = true;
      Score += scoreByLife;
      CurrentScoreSize = ScoreSize+10;
    }
  }
}

void setup()
{
  //size(800, 600);
  fullScreen(P2D);
  noCursor();
  
  /*loadSounds();
  
  music.play();
  music.loop();
  music.rate(0.85);
  music.amp(0);*/
  
  strokeWeight(2);
  background(0);
  
  Player = new PlayerClass(width/2, height/2);
  Asteroids = new ArrayList<AsteroidClass>();
  Bullets = new ArrayList<BulletClass>();
  Explosions = new ArrayList<ExplosionClass>();
  Catalysts = new ArrayList<CatalystClass>();
  Particles = new ArrayList<ParticleClass>();
  
  restart();
}

void DisplayHUD()
{
  fill(255); 
  
  if (!gameOver)
  {
    for (int i = 0; i < maxLives; i++)
    {
      noFill(); 
      if (i < Lives)
        stroke(255);
      else
        stroke(255, 40);
      pushMatrix();
      translate(15+i*30, 25);
      beginShape();
      vertex(-10, 10);
      vertex(0, -20);
      vertex(10, 10);
      vertex(0, 5);
      endShape(CLOSE);
      popMatrix();
    }
    noFill(); stroke(255);
    float w1 = 80;
    rect(5, 45, w1, 10);
    float w2 = w1*lifeScoreLerp/scoreByLife;
    fill(255); noStroke();
    rect(5, 45, w2, 10);
  }
  
  if (!dead)
  {
    textSize(CurrentScoreSize);
    String s;
    s = ""+Score;
    text(s, width/2-textWidth(s)/2, CurrentScoreSize);
    textSize(20);
    int seconds = round(time) % 60;
    int minutes = round(time) / 60;
    s = "" + (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    text(s, width-textWidth(s)-10, 30);
  }
  else
  {
    if (Lives > 0)
    {
      textSize(40); 
      String s;
      s = ""+Score;
      text(s, width/2-textWidth(s)/2, CurrentScoreSize);
      s = "RESPAWN";
      textSize(60);
      text(s, (width-textWidth(s))/2, height/2-20);
      s = ""+int(deathClock/60+1);
      textSize(120);
      text(s, (width-textWidth(s))/2, height/2+80);
    }
    else
    {
      gameOver = true;
      if (Score > MaxScore)
        MaxScore = Score;
      String s;
      textSize(100);
      s = "GAME OVER";
      text(s, (width-textWidth(s))/2, height/2-70);
      textSize(60);
      s = ""+Score;
      text(s, (width-textWidth(s))/2, height/2+40);
      textSize(20);
      s = "MAX SCORE: "+MaxScore;
      text(s, (width-textWidth(s))/2, height/2+70);
      int seconds = round(time) % 60;
      int minutes = round(time) / 60;
      s = "TIME: " + (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
      text(s, (width-textWidth(s))/2, height/2+90);
      s = "ASTEROIDS DESTROYED: "+asteroidsDestroyed;
      text(s, (width-textWidth(s))/2, height/2+110);
      if (ignoreEnterTime <= 0)
      {
        textSize(20);
        fill(255, 155+100*sin(0.3*frameCount));
        s = "PRESS ENTER TO RESTART";
        text(s, (width-textWidth(s))/2, height/2+200);
      }
    }
  }
  /*
  textSize(20);
  text(AsteroidTimer, 10, height-40);
  text(CatalystTimer, 10, height-20);
  */
}

void keyPressed()
{
  if (keyCode == KEY_SHOOT) Player.onShot = true;
  if (keyCode == KEY_THRUST) Player.thrusting = true;
  if (keyCode == KEY_LEFT) Player.rotatingLeft = true;
  if (keyCode == KEY_RIGHT) Player.rotatingRight = true;
  if (gameOver && keyCode == 10 && ignoreEnterTime <= 0) restarting = true;
  if (beginWait && keyCode == 10){restart(); beginWait = false; begin = false;}
}

void keyReleased()
{
  if (keyCode == KEY_SHOOT) Player.onShot = false;
  if (keyCode == KEY_THRUST) Player.thrusting = false;
  if (keyCode == KEY_LEFT) Player.rotatingLeft = false;
  if (keyCode == KEY_RIGHT) Player.rotatingRight = false;
}

void death()
{
  if (lifeReady)
  {
    Lives++;
    scoreByLife += scoreByLifeInc;
  }
  shake += 100;
  lifeScore = 0; 
  lifeReady = false;
  lifeReadyExplode = false;
  Explosions.add(new ExplosionClass(Player.x, Player.y, 50, 4, true));
  dead = true;
  Lives--;
  deathClock = maxDeathClock;
  Bullets.clear();
  Player.x = 0; Player.y = 0; 
  Player.vx = 0; Player.vy = 0; 
  Player.angle = 0;
  Player.thrusting = false; 
  Player.rotatingRight = false; 
  Player.rotatingLeft = false; 
  backFlash += 100;
  /*if (Lives == 0){
    game_over_sound.play();
    music.stop();
  }
  else
    death_sound.play();*/
}

void draw()
{
  background(0);
  zoom = height; zoom /= 800;
  
  lifeScoreLerp += (lifeScore-lifeScoreLerp)*0.1;
  
  CurrentScoreSize += (ScoreSize-CurrentScoreSize)*0.3;
  
  if (begin)
  {
    fill(255, beginTimer*3-30);
    String s = "ASTEROIDS";
    textSize(100);
    text(s, (width-textWidth(s))/2, height/2-5);
    
    fill(255, beginTimer*3-180);
    s = "GAME BY ZEPTEN";
    textSize(30);
    text(s, (width-textWidth(s))/2, height/2+25);
    s = "v 1.2";
    textSize(20);
    text(s, width-textWidth(s)-10, height-10);
    
    if (beginTimer < 160)
      beginTimer++;
    else
    {
      textSize(20);
      fill(255, 155+100*sin(0.3*frameCount));
      s = "PRESS ENTER TO PLAY";
      text(s, (width-textWidth(s))/2, height/2+200);
      beginWait = true;
    }
  }
  else
  {
  if (gameOver && ignoreEnterTime > 0)
    ignoreEnterTime--;
  
  if (dead && Lives > 0)
  {
    deathClock--;
    if (deathClock <= 0)
    {
      dead = false;
      Player.invincible = true;
      shake += 100;
      Explosions.add(new ExplosionClass(0, 0, 350, 15, true));
      backFlash = 100;
    }
  }
  
  if (backFlash > 0 && !restarting)
    backFlash -= 10;
  
  if (restarting)
  {
    backFlash += 10;
    if (backFlash >= 255)
      restart();
  }
  
  if (lifeReady && Lives < maxLives)
  {
    lifeScore = 0;
    lifeReady = false;
    lifeReadyExplode = false;
    scoreByLife += scoreByLifeInc;
    Lives++;
  }
  
  shake -= 0.1;
  if (shake > 5)
    shake = 5;
  else
  if (shake < 0)
    shake = 0;
    
  camX = random(-shake, shake);
  camY = random(-shake, shake);
  
  translate(width/2-camX, height/2-camY);
  
  for (int i = 0; i < Asteroids.size(); i++)
  {
    AsteroidClass a = Asteroids.get(i);
    a.update();
    a.display();
  }
  
  if (!dead)
  {
    Player.update();
    Player.display();
  }
  
  for (int i = 0; i < Explosions.size(); i++)
  {
    ExplosionClass e = Explosions.get(i);
    e.update();
    e.display();
  }
  
  for (int i = 0; i < Bullets.size(); i++)
  {
    BulletClass b = Bullets.get(i);
    b.update();
    b.display();
  }
  
  for (int i = 0; i < Catalysts.size(); i++)
  {
    CatalystClass c = Catalysts.get(i);
    c.update();
    c.display();
  }
  
  for (int i = 0; i < Particles.size(); i++)
  {
    ParticleClass p = Particles.get(i);
    p.update();
    p.display();
  }
  
  AsteroidTimer--;
  
  if (!dead && !gameOver){
    CatalystTimer--;
    time += 1/frameRate;
  }
  
  if (AsteroidTimer <= 0)
  {
    float a = random(TWO_PI);
    float aa = a + random(-0.3, 0.3);
    float v = -random(1.5, 3);
    Asteroids.add(new AsteroidClass(spawnRadius*cos(a), spawnRadius*sin(a), cos(aa)*v, sin(aa)*v, round(1+sqrt(random(sq(2))))));
    if (Score < 500000)
      AsteroidTimer = round(90-0.00012*Score);
    else
      AsteroidTimer = 30;
  }
  
  if (CatalystTimer <= 0 && !dead && !gameOver)
  {
    if (Score < 500000)
      CatalystTimer = round(500-0.0006*Score);
    else
      CatalystTimer = 200;
    Catalysts.add(new CatalystClass(random(-width/2, width/2)/zoom, random(-height/2, height/2)/zoom, 300));
  }
  
  translate(-width/2+camX, -height/2+camY);
  DisplayHUD();

  fill(255, backFlash); noStroke();
  rect(0, 0, width, height);
  }
}
