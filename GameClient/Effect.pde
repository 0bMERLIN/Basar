abstract class Effect{
    abstract void render();
    abstract boolean tick();
    boolean update(){
        this.render();
        return this.tick();
    }
}