abstract class Sprite{
    float scale = 1.0;
    abstract void render(float x, float y);

    void setScale(float scale){
        this.scale = scale;
    }

    void render(PVector pos){
        this.render(pos.x, pos.y);
    }

    abstract int getSpriteWidth();
    abstract int getSpriteHeight();

    float getWidth(){
        return this.getSpriteWidth()*this.scale;
    }

    float getHeight(){
        return this.getSpriteHeight()*this.scale;
    }
}