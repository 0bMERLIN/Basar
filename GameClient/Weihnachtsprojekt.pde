boolean LORE = true;

class WeihnachtsprojektGame implements IGame {
  Game game;
  int loreStartTime;
  int loreShownSec = 4;
  int loreSectionShown = 0;
  int loreTime;

  final String[][] LORE_STRINGS = {
    {"Weil sie unbezahlt arbeiten müssen haben die Elfen des Weihnachtsmannes",
    "eine Gewerkschaft gebildet und verweigern ihrem Meister den Gehorsam."},

    {"Nun sind sie alle geflohen und haben den Nordpol völlig verwüstet,",
      "die Weihnachtsbäume stehen in Flammen und selbst die Sternschnuppen",
    "haben sich gegen ihren Herrscher gerichtet."},

    {"Es ist schon bald Weihnachten und der Weihnachtsmann versucht",
      "verzweifelt alle Geschenke einzusammeln, die die Elfen aus Protest",
    "verstreut haben."},

    {"Kannst du ihm helfen?"}
  };

  void setup() {
    loreTime = 0;
    loreStartTime = loreTime;
    loreSectionShown = 0;

    fullScreen(P2D);
    frameRate(60);
    game = new Game();
    smooth(0);
  }

  boolean draw() {
    if (loreSectionShown < LORE_STRINGS.length && LORE) {
      drawLore();
      return false;
    }

    return drawPlaying();
  }

  void drawLore() {
    background(0);

    push();
    textSize(50);
    textAlign(CENTER);
    fill(sin(PI * (loreTime - loreStartTime) / loreShownSec / 1000.0) * 255);
    for (int i = 0; i < LORE_STRINGS[loreSectionShown].length; i++) {
      var str = LORE_STRINGS[loreSectionShown][i];
      text(str, width / 2.0, height / 2.0 + i*50.0);
    }
    fill(180);
    text("[Eine taste zum überspringen drücken]", width / 2.0, height - 100);
    pop();

    if (loreTime - loreStartTime > loreShownSec * 1000.0) {
      loreSectionShown++;
      loreStartTime = loreTime;
    }

    loreTime += 1000 / frameRate;
  }

  boolean drawPlaying() {


    // catch game over exception here!
    try {
      game.tick();
    }
    catch(SkillIssue e) {
      return true;
    }
    return false;
  }

  void keyPressed() {
    loreTime = int( (loreSectionShown+1) * 1000.0 * loreShownSec );
  }

  int getScore() {
    return game.score;
  }
}
