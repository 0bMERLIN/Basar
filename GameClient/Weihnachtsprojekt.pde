class WeihnachtsprojektGame implements IGame {
  Game game;
  
  void setup() {
    fullScreen(P2D);
    frameRate(60);
    game = new Game();
    smooth(0);
  }
  
  boolean draw() {
    // catch game over exception here!
    try{
      game.tick();
    }
    catch(SkillIssue e){
      return true;
    }
    return false;
  }
  
  void keyPressed() {
    
  }
  
  int getScore() {
    return game.score;
  }
}
