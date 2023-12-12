GameManager gameManager;

class MyGame implements IGame {
  boolean done;
  int start;

  void setup() {
    start = millis();
    done = false;
  }

  boolean draw() {
    background(10);
    text("press any key to win. score: " + getScore(), width/2, height/2);
    return done;
  }

  int getScore() {
    return int((millis() - start) / 100);
  }

  void keyPressed() {
    if (millis() - start > 500)
      done = true;
  }
}

class MyLogin implements ILogin {
  boolean unlocked;
  boolean done;
  StringBuilder username;
  String invalidUsernameCorrection;

  void setup() {
    unlocked = false;
    done = false;
    username = new StringBuilder();
    invalidUsernameCorrection = null;
  }

  boolean draw() {
    background(100);

    textSize(30); // code sometimes hangs here??
    text("LOGIN", width/2, height/2-200);
    textSize(15);

    if (invalidUsernameCorrection != null) {
      push();
      fill(255, 0, 0);
      text("Invalid username. Did you mean " + invalidUsernameCorrection, width/2-240, height/2 - 60);
      pop();
    }
    text("press any key to login as " + getUsername(), width/2, height/2);
    
    return done;
  }

  String getUsername() {
    return username.toString();
  }

  void keyPressed() {
    if (!unlocked) {
      if (key == '}')
        unlocked = true;
      return;
    }
    
    if (key == CODED) {
      if (keyCode == ENTER) {
        done = true;
      }
    } else if (key == BACKSPACE) {
      if (username.length() > 0)
        username.deleteCharAt(username.length() - 1);
    } else {
      username.append(key);
    }
  }

  void onInvalidUsername(String similar) {
    invalidUsernameCorrection = similar;
    done = false;
  }
}

class MyGameOver implements IGameOver {
  int roundsLeft;
  boolean done;
  int score, highscore;

  void setup(int roundsLeft, int score, int highscore) {
    this.roundsLeft = roundsLeft;
    this.done = false;
    this.score = score;
    this.highscore = highscore;
  }

  boolean draw() {
    background(100);

    textSize(30);
    text("GAME OVER", width/2, height/2-200);
    textSize(15);

    text("score: " + score + ", highscore: " + highscore, width/2, height/2 - 40);
    if (roundsLeft > 0) {
      text("press any key to start next round. you have " + roundsLeft + " rounds left.", width/2-120, height/2);
    } else {
      text("no more rounds left. press any key to end game.", width/2-120, height/2);
    }
    return done;
  }

  void keyPressed() {
    done = true;
  }
}

void setup() {
  size(500, 500);
  gameManager = new GameManager(new MyGame(), new MyLogin(), new MyGameOver());
  gameManager.setup();
}

void keyPressed() {
  gameManager.keyPressed();
}

void draw() {
  gameManager.draw();
}
