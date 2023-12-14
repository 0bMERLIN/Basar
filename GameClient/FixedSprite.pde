class FixedSprite extends Sprite{
    PImage sprite;

    int sprite_width;
    int sprite_height;

    FixedSprite(PImage sprite){
        this.sprite = sprite;
        this.sprite_width = sprite.width;
        this.sprite_height = sprite.height;
    }

    FixedSprite(String sprite_path){
        this(loadImageBuffered(sprite_path));
    }

    void render(float x, float y){
        image(sprite, x, y, sprite_width*scale, sprite_height*scale);
    }

    int getSpriteWidth(){
        return this.sprite_width;
    }

    int getSpriteHeight(){
        return this.sprite_height;
    }
}