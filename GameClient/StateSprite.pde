class StateSprite{
    int state;
    Sprite[] sprites;

    StateSprite(){
        state = 0;
        sprites = new Sprite[0];
    }

    void render(float x, float y){
        sprites[state].render(x, y);
    }

    void render(PVector pos){
        this.render(pos.x, pos.y);
    }

    void setState(int state){
        state = state;
    }

    void addState(Sprite sprite){
        this.sprites = (Sprite[]) append(this.sprites, sprite);
    }
}