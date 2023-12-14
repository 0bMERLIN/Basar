from PIL import Image

def is_tile_empty(tile):
    # Convert the tile to RGBA mode (to access alpha channel)
    tile = tile.convert("RGBA")
    
    # Get the alpha channel data
    alpha = tile.getchannel("A")
    
    # Check if all alpha values are 0 (completely transparent)
    return all(value == 0 for value in alpha.getdata())

def split_tileset(image_path):
    # Open the tileset image
    tileset = Image.open(image_path)

    # Get dimensions of the tileset image
    width, height = tileset.size

    # Define the size of each tile (assuming 32x32 tiles)
    tile_size = 32

    # Counter for file naming
    count = 0

    # Save an explicitly empty tile at index 0
    empty_tile = Image.new("RGBA", (tile_size, tile_size), (0, 0, 0, 0))
    empty_tile.save(f"tiles/{count}.png", "PNG")
    count += 1

    # Loop through the tileset and extract individual tiles
    for y in range(0, height, tile_size):
        for x in range(0, width, tile_size):
            # Define the region for each tile
            box = (x, y, x + tile_size, y + tile_size)
            
            # Crop the tile from the tileset
            tile = tileset.crop(box)
            
            # Check if the tile is empty and not the first one
            if count != 1 and is_tile_empty(tile):
                continue  # Skip empty tiles (excluding the first one)
            
            # Save the tile as a numbered PNG file
            tile.save(f"tiles/{count}.png", "PNG")
            count += 1

    print(f"Tileset split into {count - 1} non-empty individual tiles.")

# Path to your tileset image
tileset_path = "Tileset.png"

# Call the function with your tileset image path
split_tileset(tileset_path)
