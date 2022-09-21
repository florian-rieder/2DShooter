# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Node2D


var is_colliding = false

var speed = Vector2.ZERO
var max_count = rand_range(2,15)
var count  = 0
var skip = false

func _ready() -> void:
    visible = false

func _physics_process(_delta: float) -> void:
    
    # skip drawing half of the frames
    if skip:
        skip = false
    else:
        Surface.draw_blood(position) # draw blood to surface
        skip = true

    #Count increase until max_count, then delete
    count += 1
    if(count > max_count) : queue_free()
    
    change_velocity()
    

    #update our position based on the speed.y and speed.x
    position.y += speed.y
    position.x += speed.x

func change_velocity():
    #speed -= Vector2(rand_range(0.05, 0.1), rand_range(0.05, 0.1))
    speed.x = lerp(speed.x, 0, 0.1)
    speed.y = lerp(speed.y, 0, 0.1)
    speed.x += rand_range(-0.01,0.01)
    speed.x = clamp(speed.x, -3, 3)
    speed.y = clamp(speed.y, -3, 3)
    
