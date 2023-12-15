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
    this.hbox1 = new PVector(pos.x -35, pos.y - 35);
    this.hbox2 = new PVector(70*2, 70);
  }

  void tick() {
    pos.y = 300 + sin(millis() / 100.0 + seed) * float(seed);
    pos.x -= 5;
    calcHitbox();
  }
  
  void render(float x, float y) {
    calcHitbox();
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
    if(DEBUG) rect(this.hbox1.x + x, this.hbox1.y + y, hbox2.x, hbox2.y);

  }
}

class Elf2 extends HarmlessObstacle {
  Elf2(int x, int y) {
    this.pos = new PVector(x, y);
    this.hbox1 = new PVector(x, y);
    this.hbox2 = new PVector(64, 64);

    sprite = new AnimatedSprite("obstacles/Elf2.png", 64, 64, 8);
  }

  void tick() {
  }
}

class Elf extends HarmlessObstacle {
  Elf(int x, int y) {
    this.pos = new PVector(x, y);
    this.hbox1 = new PVector(x, y);
    this.hbox2 = new PVector(64, 64);

    sprite = new AnimatedSprite("obstacles/Elf.png", 64, 64, 8);
  }

  void tick() {
  }
}
