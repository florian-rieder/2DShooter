extends Area2D


export var damage = 200


# Called when the node enters the scene tree for the first time.
func _ready():
    # wait .1 second in order to prevent an error with the Area2D
    yield(get_tree().create_timer(0.1), "timeout")
    var bodies = get_overlapping_bodies()

    for body in bodies:
        if body.has_method('take_hit'):
            var distance = body.global_position.distance_to(global_position)/16
            var effective_damage = damage/(distance*distance)
            print(String(distance) + "  " + String(effective_damage))
            body.call('take_hit', round(effective_damage))
    
    $AnimatedSprite.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_AnimatedSprite_animation_finished():
    queue_free()
