enum GameState {
  LOGIN, GAME, GAME_OVER
}

// Lasse
interface IGame {
  // called before every round.
  void setup();

  // ._.
  boolean draw();

  // :)
  void keyPressed();
  
  // :)))))
  int getScore();
}

// Ben
interface IGameOver {
  /* called during the transition from game to game-over screen.
   * the game mgr. provides roundsLeft, score & highscore for this GUI, so it can display them.
   * when roundsLeft == 0, the next screen will be the login screen.
   */
  void setup(int roundsLeft, int score, int highscore);
  
  boolean draw();
  void keyPressed();
}

// Ben
interface ILogin {
  void setup();
  boolean draw();
  void keyPressed();
  
  /* Called when the game mgr. notices the login-GUI (this) submitting a username that doesn't exist.
   * `similar`: suggestion in case of typo.
   */
  void onInvalidUsername(String similar);

  String getUsername();
}

class GameManager {

  // state
  private GameState state;
  private String username;
  private int roundsLeft;
  private final int maxRounds = 5;
  private int highscore;

  // state handlers
  private IGame game;
  private ILogin login;
  private IGameOver gameOver;

  private void loginDraw() {
    
    if (login.draw()) {
      String verificationResult = verifyName(login.getUsername());
      
      if (verificationResult != null) {
        login.onInvalidUsername(verificationResult);
        return;
      }
      highscore = getRanking().get(login.getUsername());
      
      game.setup();
      state = GameState.GAME;
      username = login.getUsername();
      roundsLeft = maxRounds - 1;
    }
  }

  private void gameOverDraw() {
    if (gameOver.draw()) {
      if (roundsLeft > 0) {
        game.setup();
        state = GameState.GAME;
        roundsLeft--;
      } else {
        login.setup();
        state = GameState.LOGIN;
        username = "";
      }
    }
  }

  private void gameDraw() {
    if (game.draw()) {
      if (game.getScore() > highscore) highscore = game.getScore();
      gameOver.setup(roundsLeft, game.getScore(), highscore);
      state = GameState.GAME_OVER;
      postScore(username, game.getScore());
    }
  }

  public void setup() {
    state = GameState.LOGIN;
    login.setup();
    username = "";
  }

  public void draw() {
    switch (state) {
    case LOGIN:
      loginDraw();
      break;
    case GAME:
      gameDraw();
      break;
    case GAME_OVER:
      gameOverDraw();
      break;
    }
  }

  public void keyPressed() {
    switch (state) {
    case LOGIN:
      login.keyPressed();
      break;
    case GAME:
      game.keyPressed();
      break;
    case GAME_OVER:
      gameOver.keyPressed();
      break;
    }
  }

  GameManager(IGame game, ILogin login, IGameOver gameOver) {
    this.game = game;
    this.login = login;
    this.gameOver = gameOver;
  }
}
