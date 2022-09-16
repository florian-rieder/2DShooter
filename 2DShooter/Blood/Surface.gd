# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Sprite


var surface_image : Image = Image.new()
var surface_texture : ImageTexture = ImageTexture.new()
var blood_image : Image = Image.new()
var blood_texture : ImageTexture = ImageTexture.new()
var explosion_impact_image : Image = Image.new()
var explosion_impact_texture : ImageTexture = ImageTexture.new()
var surface_changed = false


func _ready() -> void:
    #create our surface image and display it
    surface_image.create(1600,1600,false,Image.FORMAT_RGBAH)
    surface_image.fill(Color(0,0,0,0))
    surface_texture.create_from_image(surface_image, 1)
    
    #We do this once, instead of every single time in blood objects
    var blood_stream_texture = load("res://Blood/blood1.png")
    blood_image = blood_stream_texture.get_data()
    blood_image.convert(Image.FORMAT_RGBAH)
    blood_texture.create_from_image(blood_image, 1)
    
    var explosion_stream_texture = load("res://Blood/ExplosionImpact.png")
    explosion_impact_image = explosion_stream_texture.get_data()
    explosion_impact_image.convert(Image.FORMAT_RGBAH)
    explosion_impact_texture.create_from_image(explosion_impact_image, 1)

    texture = surface_texture


func draw_blood(draw_pos : Vector2) -> void:
    surface_image.lock() # must lock before drawing
    #stamp the blood on to surface
    surface_image.blit_rect(blood_image,Rect2(Vector2(0,0),Vector2(3,3)),draw_pos)
    surface_image.unlock() # unlock the surface again
    surface_changed = true


func draw_explosion_impact(draw_pos : Vector2) -> void:
    surface_image.lock()
    surface_image.blend_rect(explosion_impact_image,Rect2(Vector2(0,0),Vector2(16,16)),draw_pos - Vector2(8,8))
    surface_image.unlock()
    surface_changed = true


func reset() -> void:
    surface_image.fill(Color(0,0,0,0))


func _physics_process(_delta: float) -> void:
    if not surface_changed:
        return
    #Update this surface here, instead of every blood call(better optimised
    surface_texture.create_from_image(surface_image, 1)
    surface_changed = false
