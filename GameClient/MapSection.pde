class MapSection{
    int[][] tiles;
    Collectible[] collectibles;
    Obstacle[] obstacles;
    int[] following;

    MapSection(JSONObject map_json){
        int section_width = map_json.getInt("width");
        int section_height = map_json.getInt("height");

        tiles = new int[section_width][section_height];

        for(int x = 0; x < section_width; x++){
            for(int y = 0; y < section_height; y++){
                tiles[x][y] = map_json.getJSONArray("tiles").getJSONArray(y).getInt(x);
            }
        }

        JSONArray collectibles_json = map_json.getJSONArray("collectibles");
        collectibles = new Collectible[collectibles_json.size()];

        for(int i = 0; i < collectibles.length; i++){
            JSONObject collectible_json = collectibles_json.getJSONObject(i);

            int x = collectible_json.getInt("x");
            int y = collectible_json.getInt("y");
            int value = collectible_json.getInt("value");

            collectibles[i] = new Collectible(x, y, value);
        }

        JSONArray obstacles_json = map_json.getJSONArray("obstacles");
        obstacles = new Obstacle[obstacles_json.size()];

        for(int i = 0; i < obstacles.length; i++){
            JSONObject obstacle_json = obstacles_json.getJSONObject(i);
            obstacles[i] = createObstacle(obstacle_json);
        }

        JSONArray following_json = map_json.getJSONArray("following");

        following = new int[following_json.size()];

        for (int i = 0; i < following_json.size(); i++) {
            following[i] = following_json.getInt(i);
        }
    }

    void render(float x, float y, Tile[] tileset){
        for(int ix = 0; ix < tiles.length; ix++){
            for(int iy = 0; iy < tiles[0].length; iy++){
                tileset[tiles[ix][iy]].render(ix*TILE_SIZE+x, iy*TILE_SIZE+y);
            }
        }
        for(int i = 0; i < collectibles.length; i++){
            collectibles[i].render(x, y);
        }
        for(int i = 0; i < obstacles.length; i++){
            obstacles[i].render(x, y);
            obstacles[i].tick();
        }
        if (DEBUG) line(x, 0, x, height);
    }

    void render(PVector pos, Tile[] tileset){
        this.render(pos.x, pos.y, tileset);
    }

    int getLength(){
        return TILE_SIZE*this.tiles.length;
    }

    int getRandomFollowing(){
        return following[int(random(following.length))];
    }
}
