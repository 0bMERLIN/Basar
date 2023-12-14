class Tree extends Obstacle {
  Tree(int x, int y) {
    this.pos = new PVector(x, y);
    this.hbox1 = new PVector(x, y+80);
    this.hbox2 = new PVector(80, 80);

    sprite = new AnimatedSprite("obstacles/Tree.png", 80, 160, 4);
  }

  void tick() {
  }
}

class ShootingStarObstacle extends Obstacle {
  int seed;

  ShootingStarObstacle(int x, int y) {
    this.pos = new PVector(x, y);
    seed = (int)random(100);
    calcHitbox();
    sprite = new AnimatedSprite("obstacles/ShootingStar.png", 102*2, 102, 4);
  }

  void calcHitbox() {
    this.hbox1 = new PVector(pos.x, pos.y);
    this.hbox2 = new PVector(102*2, 102);
  }

  void tick() {
    calcHitbox();

    pos.y = 300 + sin(millis() / 100.0 + seed) * float(seed);
    pos.x -= 5;
  }
  
  void render(float x, float y) {
    pushMatrix();
    float h = 60;
    float b = width;
    //Aua
    float angle = -sin(millis() / 100.0 + seed + 50/1.5) * float(seed) * 0.005;
    //text(angle, 250, 100);
    translate(pos.x + x, pos.y + y);
    rotate(angle);
    sprite.render(-sprite.getWidth() / 4, -sprite.getHeight()/2);

    popMatrix();
  }
}
