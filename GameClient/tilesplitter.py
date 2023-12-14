from PIL import Image

def split_tilemap(input_image_path, output_folder, tile_width, tile_height):
    # Open the tilemap image
    image = Image.open(input_image_path)

    # Get the dimensions of the tilemap
    map_width, map_height = image.size

    # Calculate the number of rows and columns
    num_cols = map_width // tile_width
    num_rows = map_height // tile_height

    # Iterate through each tile and save it
    for row in range(num_rows):
        for col in range(num_cols):
            # Define the coordinates of the current tile
            left = col * tile_width
            upper = row * tile_height
            right = left + tile_width
            lower = upper + tile_height

            # Crop the tile from the original image
            tile = image.crop((left, upper, right, lower))

            # Save the tile to the output folder
            tile.save(f"{output_folder}/tile_{row}_{col}.png")

if __name__ == "__main__":
    # Replace these values with your own file path and parameters
    input_image_path = "path/to/your/tilemap.png"
    output_folder = "path/to/your/output/folder"
    tile_width = 32  # Replace with your tile width in pixels
    tile_height = 32  # Replace with your tile height in pixels

    # Call the function to split the tilemap
    split_tilemap(input_image_path, output_folder, tile_width, tile_height)
