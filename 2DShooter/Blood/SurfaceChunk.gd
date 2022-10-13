# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Sprite

export var size : Vector2
var surface_image : Image = Image.new()
var surface_texture : ImageTexture = ImageTexture.new()
var surface_changed = false


func _ready() -> void:
    #create our surface image and display it
    surface_image.create(size.x, size.y,false,Image.FORMAT_RGBAH)
    surface_image.fill(Color.transparent)
    surface_texture.create_from_image(surface_image, 1)
    texture = surface_texture


func draw_image(image : Image, image_size, draw_pos : Vector2) -> void:
    surface_image.lock()
    surface_image.blend_rect(image,Rect2(Vector2(0,0),image_size),draw_pos - position - image_size/2)
    surface_image.unlock()
    surface_changed = true


func reset() -> void:
    # erase everything
    surface_image.fill(Color.transparent)
    surface_changed = true


func _physics_process(_delta: float) -> void:
    if not surface_changed:
        return
    #Update this surface here, instead of every blood call(better optimised
    surface_texture.create_from_image(surface_image, 1)
    surface_changed = false
