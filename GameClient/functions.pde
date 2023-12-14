import java.util.Map;
HashMap<String,PImage> image_buffer = new HashMap<String,PImage>();

static final int TILE_SIZE = 64;


void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
  noFill();
  if (axis == 1) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == 2) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

Object[] removeNth(Object[] l, int i){
  return (Object[]) concat(subset(l, 0, i), subset(l, i+1, l.length-i-1));
}

Obstacle createObstacle(JSONObject obstacle_json){
  int x = obstacle_json.getInt("x");
  int y = obstacle_json.getInt("y");
  int id = obstacle_json.getInt("id");

  switch (id) {
    case 0:
      return new Tree(x, y);
    case 1:
      return new ShootingStarObstacle(x, y);
    default :
      return new Tree(x, y);
  }
}

PImage loadImageBuffered(String path){
  if(image_buffer.containsKey(path)){
    return image_buffer.get(path);
  }
  else{
    PImage img = loadImage(path);
    image_buffer.put(path, img);
    return img;
  }
}


void displayScore(int score, float x, float y){
  String score_str = str(score);
  for (int i = 0; i < score_str.length(); i++) {
    PImage character = loadImageBuffered("data/font/" + score_str.charAt(i) + ".png");
    image(character, x+i*32, y, 32, 32);
  }
  image(loadImageBuffered("collectibles/gift_0.png"), x + score_str.length() * 32, y-16);
}

float clamp(float value, float minValue, float maxValue) {
  value = max(value, minValue);
  value = min(value, maxValue);
  return value;
}

class SkillIssue extends Exception {
    public SkillIssue() {
        super("SkillIssue, lol");
    }

    public SkillIssue(String message) {
        super(message);
    }
}
