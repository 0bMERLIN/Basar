class Tile{
    String name;
    boolean coll;
    boolean pass;
    PImage sprite;

    Tile(String name, boolean coll, boolean pass, String sprite_path){
        this.name = name;
        this.coll = coll;
        this.pass = pass;
        this.sprite = loadImageBuffered(sprite_path);
    }

    void render(float x, float y){
        image(this.sprite, x, y, TILE_SIZE, TILE_SIZE);
    }

    void render(PVector pos){
        this.render(pos.x, pos.y);
    }
}