# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Node


export var chunk_size : Vector2 = Vector2(200, 200)
export var total_size : Vector2 = Vector2(1600, 1600)
export var chunk_scene : PackedScene
var chunk_number = total_size/chunk_size
var chunks = []


# decal textures
var blood_image : Image = Image.new()
var blood_size

var explosion_impact_image : Image = Image.new()
var explosion_impact_size


func draw_blood(draw_pos : Vector2) -> void:
    draw_image(blood_image, draw_pos)


func draw_explosion_impact(draw_pos : Vector2) -> void:
    draw_image(explosion_impact_image, draw_pos)


func _ready() -> void:
    load_decals()
    generate_chunks()


func draw_image(image, draw_pos : Vector2) -> void:
    var chunks_to_update = []
    var image_size = image.get_size()

    # chunk directly under the given position
    var chunk_pos = get_chunk_pos_under_pos(draw_pos)
    var chunk = chunks[chunk_pos.x][chunk_pos.y]
    chunks_to_update.append(chunk)

    # In the case the decal is overlapping multiple chunks
    var out_left = draw_pos.x - image_size.x / 2 < chunk.position.x
    var out_right = draw_pos.x + image_size.x / 2 > chunk.position.x + chunk_size.x
    var out_top = draw_pos.y - image_size.y / 2 < chunk.position.y
    var out_bottom = draw_pos.y + image_size.y / 2 > chunk.position.y + chunk_size.y
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
    $SurfaceChunk.reset()


func load_decals() -> void:
    # load images
    #We do this once, instead of every single time in blood objects
    var blood_stream_texture = load("res://Blood/blood2.png")
    blood_image = blood_stream_texture.get_data()
    blood_image.convert(Image.FORMAT_RGBAH)
    blood_size = blood_image.get_size()

    var explosion_stream_texture = load("res://Blood/ExplosionImpact.png")
    explosion_impact_image = explosion_stream_texture.get_data()
    explosion_impact_image.convert(Image.FORMAT_RGBAH)
    explosion_impact_size = explosion_impact_image.get_size()

func generate_chunks() -> void:
    for x in range(chunk_number.x):
        chunks.append([])
        for y in range(chunk_number.y):
            var chunk = chunk_scene.instance()
            chunk.size = chunk_size
            add_child(chunk)
            chunk.position = Vector2(x,y) * chunk_size
            chunks[x].append(chunk)


func get_chunk_pos_under_pos(pos : Vector2):
    return Vector2(floor(pos.x/chunk_size.x),floor(pos.y/chunk_size.y))
    
