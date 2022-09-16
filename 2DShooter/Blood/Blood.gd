# adapted from:
# https://github.com/trolog/GodotPaintBloodToTexture
extends Node2D


var is_colliding = false

var speed = Vector2.ZERO

var blood_acc = rand_range(0.05,0.1)
var do_wobble = false
var max_count = rand_range(2,15)
var count  = 0


func _physics_process(_delta: float) -> void:
    Surface.draw_blood(position) # draw blood to surface

    #Count increase until max_count, then delete
    count += 1
    if(count > max_count) : queue_free()

    #We make sure blood drop faster than 3, slowly reduce speed
    if (speed.y > 3) : speed.y = 3
    speed.y = lerp(speed.y,0.1,blood_acc)

    #If we're moving downwards in a line, add wobble
    if(speed.x > 0.1 or speed.x < -0.1):
        speed.x = lerp(speed.x,0,0.1)
    else:
        do_wobble = true
    visible = false

    #we add random wobble when moving downwards to avoid str8 lines
    if(do_wobble):
        speed.x += rand_range(-0.01,0.01)
        speed.x = clamp(speed.x,-0.1,0.1)

    #update our position based on the speed.y and speed.x
    position.y += speed.y
    position.x += speed.x
