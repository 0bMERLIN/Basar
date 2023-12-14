class ParallexBackground extends Overlay{
    PImage layer1;
    PImage layer2;
    float speed;
    float speedfactor;
    float offset1;
    float offset2;

    ParallexBackground(String layer1_path, String layer2_path){
        layer1 = loadImageBuffered(layer1_path);
        layer2 = loadImageBuffered(layer2_path);
        speed = 0.4;
        speedfactor = 1.7;
        offset1 = 0;
        offset2 = 0;
    }

    void render(){
        float y = 400;
        image(layer1, -offset1, y);
        if(layer1.width - offset1 < width){
            image(layer1, -offset1+layer1.width, y);
            image(layer1, -offset1+2*layer1.width, y);
        }
        offset1+=speed;
        if(offset1 >= layer1.width){
            offset1 = 0;
        }

        image(layer2, -offset2, y);
        if(layer2.width - offset2 < width){
            image(layer2, -offset2+layer2.width, y);
            image(layer2, -offset2+2*layer2.width, y);
        }
        offset2+=speed*speedfactor;
        if(offset2 >= layer2.width){
            offset2 = 0;
        }
    }
}