class Snowflake {
  float x, y, size, speed;
}

class SnowEffect {
  private final int numberSnowflakes = 500;

  private Snowflake[] flakes;

  public SnowEffect() {
    flakes = new Snowflake[numberSnowflakes];

    for (int i = 0; i < numberSnowflakes; i++) {
      flakes[i] = new Snowflake();
      flakes[i].x = random(width);
      flakes[i].y = random(height);
      flakes[i].size = random(1, 2);
      flakes[i].speed = random(0.1, 1);
    }
  }

  public void draw() {
    fill(255);
    noStroke();

    for (int i = 0; i < numberSnowflakes; i++) {
      ellipse(flakes[i].x, flakes[i].y, flakes[i].size, flakes[i].size);
      flakes[i].y += flakes[i].speed;
      if (flakes[i].y > height)
        flakes[i].y = 0;
    }
  }
}
