class Player{
    PVector pos;
    PVector vel;
    StateSprite sprite;
    PImage heart_sprite;
    
    int hp;
    int iframes;
    
    
    float t_vel_x = 5;
    float t_vel_x_c = 6;
    float acc_x = 0.3;
    
    float t_vel_up = 15;
    float t_vel_down = 26;
    
    float g = 0.4;
    float jp = 10;
    
    
    float targetX = 600;
    
    int jumptimer = 0;
    
    Player() {
        sprite = new StateSprite();
        Sprite d = new AnimatedSprite("player/player.png", 128, 128, 6);
        heart_sprite = loadImageBuffered("player/heart.png");
        d.setScale(0.83);
        sprite.addState(d);
        pos = new PVector(300, 100);
        vel = new PVector(0, 0);
        
        hp = 3;
        iframes = 0;
    }
    
    void update(float speed, Level level, Game game) throws SkillIssue {
        vel.add(new PVector(acc_x, g));
        vel.x = clamp(vel.x, -100, pos.x < targetX ? t_vel_x_c : t_vel_x);
        vel.y = clamp(vel.y, -t_vel_up, t_vel_down);
        
        //text(jumptimer, 100, 100);
        
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
                    vel.y = 0;
                    if (coll_y1) {
                        if (keyPressed) {
                            vel.y = -jp;
                            jumptimer = 30 * steps;
                        }
                    }
                    pos.y -= nvel.y;
                    y_done = true;
                }
            }
            
            if (keyPressed && jumptimer > 0) {
                g = 0.2;
                jumptimer--;
            }
            else{
                g = 0.4;
                jumptimer = 0;
            }
            
            if (!x_done) {
                pos.x += nvel.x;
                boolean coll_x1 = level.collideX(new PVector(pos.x + 256 * 0.4 - 20, pos.y), new PVector(pos.x + 256 * 0.4 - 20, pos.y + 256 * 0.4), vel);
                if (coll_x1) {
                    pos.x -= nvel.x; 
                    vel.x = 1;
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

        if(hp <= 0){
            throw new SkillIssue("Baum");
        }
    }
    
    void render() {
        sprite.render(pos);
        //rect(pos.x, pos.y, 256 * 0.4, 256 * 0.4);
        rect(pos.x + 20, pos.y, 256 * 0.4 - 40, 256 * 0.4);
        renderHp();
        //text(hp, 100, 120);
    }

    void renderHp(){
        for(int i = 0; i < hp; i++){
            image(heart_sprite, 20+32*i, height-50);
        }
    }
}