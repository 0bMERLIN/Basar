class Level{
    //Enemy[] enemys;
    MapSection[] map;
    JSONObject[] map_sections_json;
    Tile[] tileset;
    
    float scroll_dist;
    float scroll_dist_r;
    
    float draw_x;
    float draw_y;
    
    Level() {
        loadTileset();
        loadMapSections();
        map = new MapSection[4];
        for (int i = 0; i < this.map.length; i++) {
            addMap(i, 0);
        }
        scroll_dist = 0;
        scroll_dist_r = 0;
        
        draw_x = 0;
        draw_y = 0;
    }
    
    void loadTileset() {
        tileset = new Tile[0];
        JSONArray tileset_json = loadJSONArray("level/tileset.json");
        for (int i = 0; i < tileset_json.size(); i++) {
            JSONObject tiledata = tileset_json.getJSONObject(i);
            String name = tiledata.getString("name");
            boolean coll = tiledata.getBoolean("collidable");
            boolean pass = tiledata.getBoolean("passable");
            String sprite_path = tiledata.getString("sprite");
            tileset = (Tile[]) append(tileset, new Tile(name, coll, pass, sprite_path));
        }
    }
    
    void loadMapSections() {
        int nsections = 4;
        
        this.map_sections_json = new JSONObject[0];
        for (int i = 0; i < nsections; i++) {
            this.map_sections_json = (JSONObject[]) append(this.map_sections_json, loadJSONObject("level/sections/" + str(i) + ".json"));
        }
    }
    
    void render() {
        int l = 0;
        for (int i = 0; l < width + scroll_dist_r; i++) {
            map[i].render( -scroll_dist_r + l + draw_x, draw_y, tileset);
            l += map[i].getLength();
        }
    }
    
    void scroll(float d, Game game) {
        scroll_dist += d;
        scroll_dist_r += d;
        if (scroll_dist_r > this.map[0].getLength()) {
            mapShift();
            scroll_dist_r = 0;
        } 
    }
    
    void mapShift() {
        for (int i = 0; i < this.map.length - 1; i++) {
            this.map[i] = this.map[i + 1];
        }
        addMap(this.map.length - 1, int(floor(random(map_sections_json.length))));
    }
    
    void addMap(int i, int map_id) {
        this.map[i] = new MapSection(this.map_sections_json[map_id]);
    }
    
    boolean collideCeil(PVector p1, PVector p2, PVector vel) throws SkillIssue {
        try{
            int s = 40;
            float y = p1.y - draw_y;
            
            if (y < 0) {
                return false;
            }
            
            for (int i = 0; i * s < (p2.x - p1.x) + s; i += 1) {
                float rx = p1.x + i * s;
                if (rx > p2.x) {rx = p2.x;}
                float x = rx + scroll_dist_r;
                
                int cmapi = 0;
                
                while(x >= map[cmapi].getLength()) {
                    x -= map[cmapi].getLength();
                    cmapi++;
                }
                
                int tx = (int) floor(x / TILE_SIZE);
                int ty = (int) floor(y / TILE_SIZE);
                
                
                if (tileset[map[cmapi].tiles[tx][ty]].coll && !tileset[map[cmapi].tiles[tx][ty]].pass) {
                    return true;
                }
            }
            return false;
        }
        catch(Exception e){
            throw new SkillIssue("Ded");
        }
    }
    
    boolean collideFloor(PVector p1, PVector p2, PVector vel) throws SkillIssue {
        try{
            int s = 40;
            float y = p1.y - draw_y;
            
            if (y < 0) {
                return false;
            }
            
            for (int i = 0; i * s < (p2.x - p1.x) + s; i += 1) {
                float rx = p1.x + i * s;
                if (rx > p2.x) {rx = p2.x;}
                float x = rx + scroll_dist_r;
                
                int cmapi = 0;
                
                while(x >= map[cmapi].getLength()) {
                    x -= map[cmapi].getLength();
                    cmapi++;
                }
                
                int tx = (int) floor(x / TILE_SIZE);
                int ty = (int) floor(y / TILE_SIZE);
                
                
                if (tileset[map[cmapi].tiles[tx][ty]].coll && !(tileset[map[cmapi].tiles[tx][ty]].pass && (vel.y <= p1.y - ty * TILE_SIZE))) {
                    return true;
                }
            }
            return false;
        }
        catch(Exception e){
            throw new SkillIssue("Ded");
        }
    }
    
    boolean collideX(PVector p1, PVector p2, PVector vel) throws SkillIssue {
        try{
            int s = 40;
            
            float x = p1.x + scroll_dist_r;
            int cmapi = 0;
            
            while(x >= map[cmapi].getLength()) {
                x -=map[cmapi].getLength();
                cmapi++;
            }
            
            for (int i = 0; i * s < (p2.y - p1.y) + s; i += 1) {
                float y = p1.y + i * s;
                if (y > p2.y) {y = p2.y;}
                
                int tx = (int) floor(x / TILE_SIZE);
                int ty = (int) floor(y / TILE_SIZE);
                
                if (tileset[map[cmapi].tiles[tx][ty]].coll && !tileset[map[cmapi].tiles[tx][ty]].pass) {
                    return true;
                }
            }
            
            return false;
        }
        catch(Exception e){
            throw new SkillIssue("Ded");
        }
    }
    
    int collect(PVector p1, PVector p2, Game game) {
        int collected = 0;
        
        float x = p1.x + scroll_dist_r;
        int cmapi = 0;
        
        while(x >= map[cmapi].getLength()) {
            x -= map[cmapi].getLength();
            cmapi++;
        }
        
        for (int j = 0; j < 2; j++) {
            for (int i = 0; i < map[cmapi + j].collectibles.length; i++) {
                if (map[cmapi + j].collectibles[i].aabb(new PVector(x + j * map[cmapi].getLength(), p1.y - draw_y), p2)) {
                    collected += map[cmapi + j].collectibles[i].value;
                    game.addForeGroundEffect(new CollectionEffect(p1, map[cmapi + j].collectibles[i].value));
                    map[cmapi + j].collectibles = (Collectible[]) removeNth(map[cmapi + j].collectibles, i);
                    i--;
                }
            }
        }
        return collected;
    }
    
    boolean obstacle_collision(PVector p1, PVector p2, Game game) {
        PVector p1r = new PVector(p1.x + scroll_dist_r - draw_x, p1.y - draw_y);
        
        for (int i = 0; i < map[0].obstacles.length; i++) {
            if (map[0].obstacles[i].aabb(p1r, p2)) {
                return true;
            }
        }
        PVector p1r2 = new PVector(p1.x + scroll_dist_r - draw_x, p1.y - draw_y);
        for (int i = 0; i < map[1].obstacles.length; i++) {
            if (map[1].obstacles[i].aabb(p1r2, p2, map[0].getLength())) {
                return true;
            }
        }
        
        return false;
    }
    
    
}
