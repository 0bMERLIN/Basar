import sys
import pygame
import os
import json

TILE_SIZE = 32
W, H = 800, 600
TILES_PER_ROW = W // TILE_SIZE
TILES_FOLDER = "tiles/"
SPRITES_FOLDER = "sprites/"
TILES_FILE = sys.argv[1]

tilemap = [[-1 for _ in range(W // TILE_SIZE)] for _ in range(H // TILE_SIZE)]
collectibles = []

def save_tilemap():
    data = {
        "width": W // TILE_SIZE,
        "height": H // TILE_SIZE,
        "tiles": tilemap,
        "collectibles": collectibles
    }

    with open(TILES_FILE, 'w') as file:
        json.dump(data, file, indent=4)

def load_tilemap():
    global W, H, tilemap, collectibles
    with open(TILES_FILE, 'r') as file:
        data = json.load(file)

        W, H = data["width"] * TILE_SIZE, data["height"] * TILE_SIZE
        tilemap = data.get('tiles', [])
        collectibles = data.get('collectibles', [])

load_tilemap()
pygame.init()
screen = pygame.display.set_mode((W, H))
pygame.display.set_caption("Simple Tile Editor")

tiles = [pygame.image.load(os.path.join(TILES_FOLDER, filename)).convert_alpha()
         for filename in os.listdir(TILES_FOLDER) if filename.endswith(".png")]

sprites = [pygame.image.load(os.path.join(SPRITES_FOLDER, filename)).convert_alpha()
           for filename in sorted(os.listdir(SPRITES_FOLDER)) if filename.endswith(".png")]

camera_x = camera_y = 0
selected_tile = 0
selected_collectible = 0
mode = "tiles"
running = True
drawing = False
snapping = True

while running:
    screen.fill(0)

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
            elif event.key == pygame.K_m:
                mode = "tiles" if mode == "collectibles" else "collectibles"
        
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if mode == "tiles" and event.button == 1:
                menu_height = ((len(tiles) - 1) // TILES_PER_ROW + 1) * TILE_SIZE
                selected_tile = (event.pos[1] // TILE_SIZE * TILES_PER_ROW +
                                    event.pos[0] // TILE_SIZE) if event.pos[1] < menu_height else selected_tile
                drawing = event.pos[1] >= menu_height
            
            elif mode == "collectibles" and event.button == 1:
                x, y = event.pos
                
                w,h = sprites[selected_collectible].get_width(), sprites[selected_collectible].get_height()
                if snapping:
                    collectibles.append({
                        "x": ((x + camera_x) // TILE_SIZE) * TILE_SIZE + 1, 
                        "y": ((y + camera_y) // TILE_SIZE) * TILE_SIZE + 1,
                        "value": selected_collectible,
                        "obstacle": False
                    })
                else:
                    collectibles.append({
                        "x": x + camera_x - w / 2, 
                        "y": y + camera_y - h,
                        "value": selected_collectible,
                        "obstacle": False
                    })
            
            elif mode == "collectibles" and event.button == 2:
                x, y = event.pos
                for c in collectibles:
                    cx,cy,id_ = c["x"], c["y"], c["value"]
                    w,h = sprites[selected_collectible].get_width(), sprites[selected_collectible].get_height()
                    if x > cx and x < cx + w and y > cy and y < cy + h: c["obstacle"] = True

            
            elif mode == "collectibles" and event.button == 3:
                x, y = event.pos
                acc = []
                for c in collectibles:
                    cx,cy,id_ = c["x"], c["y"], c["value"]
                    w,h = sprites[selected_collectible].get_width(), sprites[selected_collectible].get_height()
                    if x > cx and x < cx + w and y > cy and y < cy + h: continue
                    acc += [c]
                collectibles = acc
        
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

    for y, row in enumerate(tilemap):
        for x, tile_index in enumerate(row):
            if tile_index != -1:
                screen.blit(tiles[tile_index], (x * TILE_SIZE - camera_x, y * TILE_SIZE - camera_y))

    for c in collectibles:
        x, y, sprite_index, obstacle = c["x"], c["y"], c["value"], c["obstacle"]
        screen.blit(sprites[sprite_index], (x - camera_x, y - camera_y))
        if obstacle:
            pygame.draw.rect(screen, (255, 0, 0), (x, y, TILE_SIZE, TILE_SIZE), 2)
    
    if mode == "tiles":
        for i, tile in enumerate(tiles):
            x, y = (i % TILES_PER_ROW) * TILE_SIZE, (i // TILES_PER_ROW) * TILE_SIZE
            screen.blit(tile, (x, y))
            if i == selected_tile:
                pygame.draw.rect(screen, (255, 0, 0), (x, y, TILE_SIZE, TILE_SIZE), 2)
    else:
        for i, sprite in enumerate(sprites):
            x, y = (i % TILES_PER_ROW) * TILE_SIZE, (i // TILES_PER_ROW) * TILE_SIZE + H - TILE_SIZE * 2
            screen.blit(sprite, (x, y))
            if i == selected_collectible:
                pygame.draw.rect(screen, (255, 0, 0), (x, y, TILE_SIZE, TILE_SIZE), 2)

    pygame.display.flip()

    if drawing:
        mouse_x, mouse_y = pygame.mouse.get_pos()
        if mouse_y < H - TILE_SIZE:
            tile_x, tile_y = (mouse_x + camera_x) // TILE_SIZE, (mouse_y + camera_y) // TILE_SIZE
            if 0 <= tile_x < W // TILE_SIZE and 0 <= tile_y < H // TILE_SIZE:
                tilemap[tile_y][tile_x] = selected_tile

pygame.quit()
