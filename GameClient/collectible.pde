class Collectible{
    PVector pos;
    PVector hbox;

    int value;

    PImage sprite;

    Collectible(int x, int y, int value){
        this.pos = new PVector(x, y);
        this.value = value;

        this.hbox = new PVector(64, 64);

        if(value >= 5){
            sprite = loadImageBuffered("collectibles/gift_1.png");
        }
        else{
            sprite = loadImageBuffered("collectibles/gift_0.png");
        }
    }

    boolean aabb(PVector c_pos, PVector c_hbox, int x_offset){
        return c_pos.x < pos.x + hbox.x + x_offset && c_pos.x + c_hbox.x > pos.x + x_offset && c_pos.y < pos.y + hbox.y && c_pos.y + c_hbox.y > pos.y;
    }

    boolean aabb(PVector c_pos, PVector c_hbox){
        return this.aabb(c_pos, c_hbox, 0);
    }

    void render(float x, float y){
        image(this.sprite, x + pos.x, y + pos.y);
        if (HITBOXES) rect(x + pos.x, y + pos.y, 64, 64);
    }

    void render(PVector pos){
        this.render(pos.x, pos.y);
    }
}
