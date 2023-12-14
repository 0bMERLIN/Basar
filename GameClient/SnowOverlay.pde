class SnowOverlay extends Overlay{
    PImage white;
    PImage gray;

    SnowOverlay(){
        white = loadImageBuffered("overlays/snow/white.png");
        gray = loadImageBuffered("overlays/snow/gray.png");
    }

    void render(){
        int offset1 = (millis()/15)%(white.height);
        int offset2 = (millis()/20)%(gray.height);

        for(int x = 0; x-1 < (width/gray.width); x++){
            for(int y = -1; y-1 < (width/gray.height); y++){
                image(gray, x*gray.width, y*gray.height + offset2);
            }
        }
        for(int x = 0; x-1 < (width/white.width); x++){
            for(int y = -1; y-1 < (width/white.height); y++){
                image(white, x*white.width, y*white.height + offset1);
            }
        }
        //text(frameRate, 100, 100);
    }   
}