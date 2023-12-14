class Player{
    PVector pos;
    PVector vel;
    StateSprite sprite;
    
    int hp;
    int iframes;
    
    float targetX = 450;
    
    Player() {
        sprite = new StateSprite();
        Sprite d = new AnimatedSprite("player/player.png", 128, 128, 6);
        d.setScale(0.75);
        sprite.addState(d);
        pos = new PVector(300, 100);
        vel = new PVector(0, 0);
        
        hp = 3;
        iframes = 0;
    }
    
    void update(float speed, Level level, Game game) {
        vel.add(new PVector(0, 0.4));
        vel.y = clamp(vel.y, -15, 15);
        
        if (pos.x < targetX) {
            vel.x = speed + 1;
        }
        else{
            vel.x = speed;
        }
        
        pos.x -= speed;
        
        int steps = 64;
        
        PVector nvel = PVector.div(vel, steps);
        
        boolean x_done = false;
        boolean y_done = false;
        
        for (int i = 0; i < steps; i++) {
            
            if (!y_done) {
                pos.y += nvel.y;
                
                boolean coll_y1 = level.collideFloor(new PVector(pos.x + 20, pos.y + 256 * 0.4), new PVector(pos.x + 256 * 0.4 - 20, pos.y + 256 * 0.4), vel);
                boolean coll_y2 = level.collideCeil(new PVector(pos.x + 20, pos.y), new PVector(pos.x + 256 * 0.4 - 20, pos.y), vel);
                if (coll_y1 || coll_y2) {
                    vel = new PVector(0, 0);
                    if (coll_y1) {
                        if (keyPressed) {
                            vel = new PVector(0, -30);
                        }
                    }
                    pos.y -= nvel.y;
                    y_done = true;
                }
            }
            
            if (!x_done) {
                pos.x += nvel.x;
                boolean coll_x1 = level.collideX(new PVector(pos.x + 256 * 0.4 - 20, pos.y), new PVector(pos.x + 256 * 0.4 - 20, pos.y + 256 * 0.4), vel);
                if (coll_x1) {
                    pos.x -= nvel.x; 
                }
            }
        }
        
        game.score += level.collect(new PVector(pos.x, pos.y), new PVector(256 * 0.4, 256 * 0.4), game);
        
        if (iframes <= 0) {
            if (level.obstacle_collision(new PVector(pos.x + 20, pos.y), new PVector(256 * 0.4 - 40, 256 * 0.4), game)) {
                hp--;
                iframes = 60;
            }
        }
        else{
            iframes--;
        }
    }
    
    void render() {
        sprite.render(pos);
        rect(pos.x, pos.y, 256 * 0.4, 256 * 0.4);
        rect(pos.x + 20, pos.y, 256 * 0.4 - 40, 256 * 0.4);
        //text(hp, 100, 120);
    }
}
