class CollectionEffect extends Effect {
    float t;
    Sprite sprite;
    float speed;

    PVector spawn_pos;
    PVector dest;
    PVector pos;

    CollectionEffect(PVector spawn_pos, int value){
        t = 0;
        if(value >= 5){
            sprite = new FixedSprite("collectibles/gift_1.png");
        }
        else{
            sprite = new FixedSprite("collectibles/gift_0.png");
        }
        speed = 2;
        this.spawn_pos = spawn_pos;
        this.pos = new PVector(spawn_pos.x, spawn_pos.y);
        this.dest = new PVector(100 + getDiplayPresentXOffset(), 50);
    }

    boolean tick(){
        t++;
        pos = PVector.add(spawn_pos, PVector.sub(dest, spawn_pos).mult(t/30));
        return (t == 30);
    }

    void render(){
        sprite.render(pos.x, pos.y);
        //text("" + pos.x + " " + pos.y, 300, 100);
    }
}