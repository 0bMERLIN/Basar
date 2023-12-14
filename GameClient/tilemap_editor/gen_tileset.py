import json
import os

TILES_FOLDER = "tiles/"

with open("../data/level/tileset.json", "w") as f:
    j = json.dumps([{
            "name": str(n),
            "collidable": n != 0,
            "passable": False,
            "sprite": f"level/tiles/{n}.png"
        } for n in range(0, len(os.listdir(TILES_FOLDER)))])
    f.write(j)
