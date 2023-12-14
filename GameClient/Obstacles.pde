class Tree extends Obstacle{
    Tree(int x, int y){
        this.pos = new PVector(x, y);
        this.hbox1 = new PVector(x, y);
        this.hbox2 = new PVector(64, 64);

        sprite = loadImageBuffered("obstacles/tree_0.png");
        sprite.resize(64, 64);
    }

    void tick(){

    }
}
