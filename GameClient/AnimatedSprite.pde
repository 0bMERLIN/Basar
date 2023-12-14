class AnimatedSprite extends Sprite{
    PImage sprite_sheet;
    int frame;
    int n_frames;
    int frame_counter;
    int frame_delay;

    int sprite_width;
    int sprite_height;

    AnimatedSprite(PImage sprite_sheet, int sprite_width, int sprite_height, int frame_delay){
        this.sprite_sheet = sprite_sheet;
        this.frame = 0;
        this.frame_counter = 0;
        this.n_frames = sprite_sheet.width/sprite_width;
        this.frame_delay = frame_delay;

        this.sprite_width = sprite_width;
        this.sprite_height = sprite_height;
    }

    AnimatedSprite(String sprite_sheet_path, int sprite_width, int sprite_height, int frame_delay){
        this(loadImageBuffered(sprite_sheet_path), sprite_width, sprite_height, frame_delay);
    }

    void render(float x, float y){
        image(sprite_sheet, x, y, sprite_width*scale, sprite_height*scale, frame*sprite_width, 0, frame*sprite_width+sprite_width, sprite_height);
        this.advance();
    }

    void advance(){
        frame_counter++;
        if(frame_counter == frame_delay){
            frame_counter = 0;
            frame++;
            if(frame == n_frames){
                frame = 0;
            }
        }
    }

    int getSpriteWidth(){
        return this.sprite_width;
    }

    int getSpriteHeight(){
        return this.sprite_height;
    }
}