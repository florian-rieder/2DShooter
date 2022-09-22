extends Node


export var chunk_size : Vector2 = Vector2(200, 200)
export var total_size : Vector2 = Vector2(1600, 1600)
export var chunk_scene : PackedScene
var chunk_number : Vector2 = total_size / chunk_size
var chunks = []

# decal textures. Both dictionaries use decal name for keys
export var decal_paths : Dictionary = Dictionary()
var decals : Dictionary = Dictionary()


func draw_blood(draw_pos : Vector2) -> void:
    draw_image(decals['Blood'], draw_pos)


func draw_explosion_impact(draw_pos : Vector2) -> void:
    draw_image(decals['ExplosionImpact'], draw_pos)


func _ready() -> void:
    load_decals()
    generate_chunks()


func load_decals() -> void:
    # load decals
    # we do this once, instead of every single time in blood objects
    for key in decal_paths:
        var stream_texture = load(decal_paths[key])
        var image = stream_texture.get_data()
        image.convert(Image.FORMAT_RGBAH)
        decals[key] = image


func draw_image(image, draw_pos : Vector2) -> void:
    var chunks_to_update = []
    var image_size = image.get_size()

    # chunk directly under the given position
    var chunk_pos = get_chunk_pos_under_pos(draw_pos)

    # check that we're not trying to render stuff out of the surface
    if chunk_pos.x >= chunk_number.x or chunk_pos.x < 0 or chunk_pos.y >= chunk_number.y or chunk_pos.y < 0:
        return

    var chunk = chunks[chunk_pos.x][chunk_pos.y]
    chunks_to_update.append(chunk)

    # In the case the decal is overlapping multiple chunks:
    # Find out on which side(s) the image is out of bounds
    var out_left = draw_pos.x - image_size.x / 2 < chunk.position.x and chunk_pos.x-1 >= 0
    var out_right = draw_pos.x + image_size.x / 2 > chunk.position.x + chunk_size.x and chunk_pos.x+1 < chunk_number.x
    var out_top = draw_pos.y - image_size.y / 2 < chunk.position.y and chunk_pos.y-1 >= 0
    var out_bottom = draw_pos.y + image_size.y / 2 > chunk.position.y + chunk_size.y and chunk_pos.y+1 < chunk_number.y

    # select the adjacent chunk(s) in the direction of the overlap
    # FIXME: There must be a better way
    if out_left:
        chunks_to_update.append(chunks[chunk_pos.x-1][chunk_pos.y])
    if out_right:
        chunks_to_update.append(chunks[chunk_pos.x+1][chunk_pos.y])
    if out_top:
        chunks_to_update.append(chunks[chunk_pos.x][chunk_pos.y-1])
    if out_bottom:
        chunks_to_update.append(chunks[chunk_pos.x][chunk_pos.y+1])
    if out_left and out_top:
        chunks_to_update.append(chunks[chunk_pos.x-1][chunk_pos.y-1])
    if out_left and out_bottom:
        chunks_to_update.append(chunks[chunk_pos.x-1][chunk_pos.y+1])
    if out_right and out_top:
        chunks_to_update.append(chunks[chunk_pos.x+1][chunk_pos.y-1])
    if out_right and out_bottom:
        chunks_to_update.append(chunks[chunk_pos.x+1][chunk_pos.y+1])

    # update all affected chunks
    for c in chunks_to_update:
        c.draw_image(image, image_size, draw_pos)


func reset() -> void:
    # reset every chunk
    for x in range(chunk_number.x):
        for y in range(chunk_number.y):
            chunks[x][y].reset()


func generate_chunks() -> void:
    for x in range(chunk_number.x):
        chunks.append([])
        for y in range(chunk_number.y):
            var chunk = chunk_scene.instance()
            chunk.size = chunk_size
            add_child(chunk)
            chunk.position = Vector2(x,y) * chunk_size
            chunks[x].append(chunk)


# get the chunk position of the chunk containing the given position
func get_chunk_pos_under_pos(pos : Vector2):
    return Vector2(floor(pos.x/chunk_size.x),floor(pos.y/chunk_size.y))
