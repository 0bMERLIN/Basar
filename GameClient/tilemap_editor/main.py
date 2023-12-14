import sys
import pygame
import pygame.transform
import os
import json

TILE_SIZE = 64
W, H = 800, 600
TILES_FOLDER = "tiles/"
SPRITES_FOLDER = "sprites/"
TILES_FILE = sys.argv[1]

tilemap = [[0 for _ in range(W // TILE_SIZE)] for _ in range(H // TILE_SIZE)]
obstacles = []
collectibles = []
following = []

def resize_tilemap(new_width, new_height):
    if new_width <= 1 or new_height <= 1: return
    global W, H, tilemap, obstacles, following

    old_width = len(tilemap[0])
    old_height = len(tilemap)

    # Create a new empty tilemap with the new dimensions
    new_tilemap = [[0 for _ in range(new_width)] for _ in range(new_height)]

    # Copy over the existing tile data to the new tilemap
    for y in range(min(old_height, new_height)):
        for x in range(min(old_width, new_width)):
            new_tilemap[y][x] = tilemap[y][x]

    # Update width and height
    W, H = new_width * TILE_SIZE, new_height * TILE_SIZE

    # Update references to the new tilemap
    tilemap = new_tilemap


def save_tilemap():
    data = {
        "width": W // TILE_SIZE,
        "height": H // TILE_SIZE,
        "tiles": tilemap,
        "obstacles": obstacles,
        "following": following,
        "collectibles": collectibles
    }

    with open(TILES_FILE, 'w') as file:
        json.dump(data, file, indent=4)

def load_tilemap():
    global W, H, tilemap, obstacles, following, collectibles
    with open(TILES_FILE, 'r') as file:
        data = json.load(file)

        W, H = data["width"] * TILE_SIZE, data["height"] * TILE_SIZE
        tilemap = data.get('tiles', [])
        obstacles = data.get('obstacles', [])
        following = data.get("following", [])
        collectibles = data.get("collectibles", [])

load_tilemap()
pygame.init()
screen = pygame.display.set_mode((1000, 800))
font = pygame.font.Font(None, 36)
pygame.display.set_caption("Tile Editor")

def display_text(text, x, y, color=(255, 255, 255)):
    text_surface = font.render(text, True, color)
    screen.blit(text_surface, (x, y))


def tiles_per_row():
    return screen.get_width() // TILE_SIZE

tiles = [pygame.transform.scale(pygame.image.load(os.path.join(TILES_FOLDER, filename)).convert_alpha(), (TILE_SIZE,)*2)
         for filename in sorted(os.listdir(TILES_FOLDER), key=lambda fname: int(fname.replace(".png", ""))) if filename.endswith(".png")]

sprites = [pygame.transform.scale(pygame.image.load(os.path.join(SPRITES_FOLDER, filename)).convert_alpha(), (TILE_SIZE,)*2)
           for filename in sorted(os.listdir(SPRITES_FOLDER)) if filename.endswith(".png")]

camera_x = camera_y = 0
selected_tile = 0
selected_collectible = 0
mode = "tiles"
running = True
drawing = False
snapping = True

while running:
    screen.fill((100,)*3)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_a:
                camera_x -= TILE_SIZE
            elif event.key == pygame.K_d:
                camera_x += TILE_SIZE
            elif event.key == pygame.K_w:
                camera_y -= TILE_SIZE
            elif event.key == pygame.K_s:
                camera_y += TILE_SIZE
            elif event.key == pygame.K_PERIOD:
                snapping = not snapping
            elif event.key == pygame.K_SPACE:
                save_tilemap()
            elif event.key == pygame.K_1: resize_tilemap(W//TILE_SIZE - 1, H//TILE_SIZE)
            elif event.key == pygame.K_2: resize_tilemap(W//TILE_SIZE + 1, H//TILE_SIZE)
            elif event.key == pygame.K_3: resize_tilemap(W//TILE_SIZE, H//TILE_SIZE - 1)
            elif event.key == pygame.K_4: resize_tilemap(W//TILE_SIZE, H//TILE_SIZE + 1)
            elif event.key == pygame.K_m:
                match mode:
                    case "tiles": mode = "obstacles"
                    case "obstacles": mode = "collectibles"
                    case "collectibles": mode = "tiles"
                    case _: mode = "tiles"
        
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if mode == "tiles" and event.button == 1:
                menu_height = ((len(tiles) - 1) // tiles_per_row() + 1) * TILE_SIZE
                new_selected_tile = event.pos[1] // TILE_SIZE * tiles_per_row() + event.pos[0] // TILE_SIZE
                selected_tile = new_selected_tile if 0 <= new_selected_tile < len(tiles) else selected_tile
                drawing = event.pos[1] >= menu_height
            
            elif mode == "obstacles" and event.button == 1:
                x, y = event.pos
                
                w,h = sprites[selected_collectible].get_width(), sprites[selected_collectible].get_height()
                if snapping:
                    obstacles.append({
                        "x": ((x + camera_x) // TILE_SIZE) * TILE_SIZE + 1, 
                        "y": ((y + camera_y) // TILE_SIZE) * TILE_SIZE + 1,
                        "id": selected_collectible
                    })
                else:
                    obstacles.append({
                        "x": x + camera_x - w / 2, 
                        "y": y + camera_y - h,
                        "id": selected_collectible
                    })
            
            elif mode == "collectibles" and event.button == 1:
                x, y = event.pos
                
                if snapping:
                    collectibles.append({
                        "x": ((x + camera_x) // TILE_SIZE) * TILE_SIZE + 1, 
                        "y": ((y + camera_y) // TILE_SIZE) * TILE_SIZE + 1,
                        "value": 0
                    })
                else:
                    collectibles.append({
                        "x": x + camera_x - w / 2, 
                        "y": y + camera_y - h,
                        "value": 0
                    })
            
            elif mode == "obstacles" and event.button == 3:
                x, y = event.pos
                acc = []
                for c in obstacles:
                    cx,cy,id_ = c["x"], c["y"], c["id"]
                    w,h = sprites[selected_collectible].get_width(), sprites[selected_collectible].get_height()
                    if x > cx-camera_x and x < cx-camera_x + w and y > cy-camera_y and y < cy + h-camera_y: continue
                    acc += [c]
                obstacles = acc
            
            elif mode == "collectibles" and event.button == 3:
                x, y = event.pos
                acc = []
                for c in collectibles:
                    cx,cy,value = c["x"], c["y"], c["value"]
                    if x > cx-camera_x and x < cx-camera_x + TILE_SIZE and y > cy-camera_y and y < cy + TILE_SIZE-camera_y: continue
                    acc += [c]
                collectibles = acc
                
            elif mode == "collectibles" and event.button == 2:
                x, y = event.pos
                for c in collectibles:
                    cx,cy,value = c["x"], c["y"], c["value"]
                    if x > cx-camera_x and x < cx-camera_x + TILE_SIZE \
                            and y > cy-camera_y and y < cy + TILE_SIZE-camera_y:
                        c["value"] = value + 1

        elif event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:
                drawing = False
        
        elif event.type == pygame.MOUSEWHEEL:
            if mode == "tiles":
                selected_tile -= event.y
                selected_tile %= len(tiles)
            else:
                selected_collectible -= event.y
                selected_collectible %= len(sprites)

    pygame.draw.rect(screen, (0, 0, 0), (-camera_x, -camera_y, W, H))

    for y, row in enumerate(tilemap):
        for x, tile_index in enumerate(row):
            if tile_index != -1:
                screen.blit(tiles[tile_index], (x * TILE_SIZE - camera_x, y * TILE_SIZE - camera_y))

    for c in obstacles:
        x, y, sprite_index = c["x"], c["y"], c["id"]
        screen.blit(sprites[sprite_index], (x - camera_x, y - camera_y))
    
    for c in collectibles:
        x, y, value = c["x"], c["y"], c["value"]
        display_text(str(value), x-camera_x, y-camera_y, color=(255,0,0))
        pygame.draw.rect(screen, (255, 0, 0), (x-camera_x, y-camera_y, TILE_SIZE, TILE_SIZE), 2)

    if mode == "tiles":
        menu_height = ((len(tiles) - 1) // tiles_per_row() + 1) * TILE_SIZE
        pygame.draw.rect(screen, (0, 0, 0), (0, 0, screen.get_width(), menu_height))

        for i, tile in enumerate(tiles):
            x, y = (i % tiles_per_row()) * TILE_SIZE, (i // tiles_per_row()) * TILE_SIZE
            screen.blit(tile, (x, y))
            if i == selected_tile:
                pygame.draw.rect(screen, (255, 0, 0), (x, y, TILE_SIZE, TILE_SIZE), 2)
    elif mode == "obstacles":
        for i, sprite in enumerate(sprites):
            x, y = (i % tiles_per_row()) * TILE_SIZE, 0
            screen.blit(sprite, (x, y))
            if i == selected_collectible:
                pygame.draw.rect(screen, (255, 0, 0), (x, y, TILE_SIZE, TILE_SIZE), 2)
    
    pygame.display.flip()

    if drawing:
        mouse_x, mouse_y = pygame.mouse.get_pos()
        tile_x, tile_y = (mouse_x + camera_x) // TILE_SIZE, (mouse_y + camera_y) // TILE_SIZE
        if 0 <= tile_x < W // TILE_SIZE and 0 <= tile_y < H // TILE_SIZE:
                tilemap[tile_y][tile_x] = selected_tile

pygame.quit()
