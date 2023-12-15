class Game{
    Player player;
    Level level;
    Overlay background_overlay;
    Overlay snow_overlay;

    Effect[] background_effects;
    Effect[] foreground_effects;

    int score;

    int random_cooldown;

    float speed_factor = 1.0;
    
    Game(){
        player = new Player();
        level = new Level();
        background_overlay = new ParallexBackground("overlays/mountains/mountains_back.png", "overlays/mountains/mountains_front.png");
        snow_overlay = new SnowOverlay();

        background_effects = new Effect[0];
        foreground_effects = new Effect[0];

        score = 0;

        setRandomCooldown();
    }

    void tick() throws SkillIssue {
        setGradient(0, 0, width, height, color(#001744), color(#39364d), 1);
        renderBackgroundEffects();
        snow_overlay.render();
        background_overlay.render();
        level.render();
        player.render();
        level.scroll(speed_factor, this);
        player.update(speed_factor, level, this);
        renderForegroundEffects();
        displayScore(score, 50, 50);

        randomEffects();
    }

    void renderBackgroundEffects(){
        for(int i = 0; i < background_effects.length; i++){
            if(background_effects[i].update()){
                background_effects = (Effect[]) removeNth(background_effects, i);
                i--;
            }
        }
    }

    void renderForegroundEffects(){
        for(int i = 0; i < foreground_effects.length; i++){
            if(foreground_effects[i].update()){
                foreground_effects = (Effect[]) removeNth(foreground_effects, i);
                i--;
            }
        }
    }

    void addBackGroundEffect(Effect effect){
        background_effects = (Effect[]) append(background_effects, effect);
    }

    void addForeGroundEffect(Effect effect){
        foreground_effects = (Effect[]) append(foreground_effects, effect);
    }

    void randomEffects(){
        if(checkRandowCooldown()){
            addBackGroundEffect(new ShootingStar());
        }
    }

    void setRandomCooldown(){
        random_cooldown = int(random(20*60, 40*60));
    }

    boolean checkRandowCooldown(){
        //text(random_cooldown, 150, 100);
        if(random_cooldown <= 0){
            setRandomCooldown();
            return true;
        }
        random_cooldown--;
        return false;
    }

    void gameOver(){
        exit();
    }
}
