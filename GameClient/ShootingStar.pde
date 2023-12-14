class ShootingStar extends Effect{
    float t;
    Sprite sprite;
    float speed;

    ShootingStar(){
        t = 0;
        sprite = new AnimatedSprite("effects/shooting_star.png", 128, 64, 3);
        speed = 2;
    }

    boolean tick(){
        t += speed;
        if(t >= width + sprite.getWidth()){
            return true;
        }
        return false;
    }

    void render(){
        pushMatrix();
        float h = 60;
        float b = width;
        //Aua
        float angle = atan((PI*h*cos((PI*t)/b))/b);
        //text(angle, 250, 100);
        translate(width-t, 140-(h*sin(t*(PI/width))));
        rotate(angle);
        sprite.render(0, 0);
        popMatrix();
    }
}