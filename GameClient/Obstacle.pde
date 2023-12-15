boolean HITBOXES = false;


abstract class Obstacle {
  PVector pos;

  PVector hbox1;
  PVector hbox2;

  Sprite sprite;

  boolean aabb(PVector c_pos, PVector c_hbox, int x_offset) {
    return c_pos.x < hbox1.x + hbox2.x + x_offset && c_pos.x + c_hbox.x > hbox1.x + x_offset && c_pos.y < hbox1.y + hbox2.y && c_pos.y + c_hbox.y > hbox1.y;
  }

  boolean aabb(PVector c_pos, PVector c_hbox) {
    return this.aabb(c_pos, c_hbox, 0);
  }

  abstract void tick();

  void render(float x, float y) {
    push();
    sprite.render(new PVector(x+pos.x, y+pos.y));
    pop();
    if (HITBOXES) rect(x + hbox1.x, y + hbox1.y, hbox2.x, hbox2.y);
  }

  void render(PVector pos) {
    this.render(pos.x, pos.y);
  }
}

abstract class HarmlessObstacle extends Obstacle {
  boolean aabb(PVector c_pos, PVector c_hbox, int x_offset) {
    return false;
  }
}
