# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Sprite

class_name paint

var surface_image : Image = Image.new()
var surface_texture : ImageTexture = ImageTexture.new()
var blood_image : Image = Image.new()
var blood_texture : ImageTexture = ImageTexture.new()

func _ready() -> void:
    #create our surface image and display it
    surface_image.create(1600,1500,false,Image.FORMAT_RGBAH)
    surface_image.fill(Color(0,0,0,0))
    surface_texture.create_from_image(surface_image, 1)
    
    #We do this once, instead of every single time in blood objects
    var blood_stream_texture = load("res://Blood/blood1.png")
    blood_image = blood_stream_texture.get_data()
    blood_image.convert(Image.FORMAT_RGBAH)
    blood_texture.create_from_image(blood_image, 1)

    texture = surface_texture


func draw_blood(draw_pos : Vector2) -> void:
    surface_image.lock() # must lock before drawing
    #stamp the blood on to surface
    surface_image.blit_rect(blood_image,Rect2(Vector2(0,0),Vector2(3,3)),draw_pos)
    surface_image.unlock() # unlock the surface again


func reset() -> void:
    surface_image.fill(Color(0,0,0,0))


func _physics_process(_delta: float) -> void:
    #Update this surface here, instead of every blood call(better optimised
    surface_texture.create_from_image(surface_image, 1)
    
    #Reset the texture so it's empty again
#    if(Input.is_action_just_pressed("ui_accept")):
#        surface_image.fill(Color(0,0,0,0))
#
#    #Allow drawing with the right mouse button
#    if(Input.is_action_pressed("fire")):
#        draw_blood(get_global_mouse_position())
