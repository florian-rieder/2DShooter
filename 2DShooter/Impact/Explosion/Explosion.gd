extends Area2D

signal explosion(shake_trauma, position)

export var damage = 200
export var trauma = 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
    GlobalSignal.add_emitter('explosion', self)
    # wait .1 second in order to prevent an error with the Area2D
    yield(get_tree().create_timer(0.1), "timeout")
    GlobalSignal.emit_signal_when_ready("explosion", [trauma, global_position], self)
    var bodies = get_overlapping_bodies()

    for body in bodies:
        if body.has_method('take_hit'):
            var distance = body.global_position.distance_to(global_position)/16
            var hit_direction = global_position.direction_to(body.global_position)
            var effective_damage = damage
            if distance != 0:
                effective_damage = damage/(distance*distance)
            body.call('take_hit', round(effective_damage), hit_direction)
    
    $AnimatedSprite.playing = true
    Surface.draw_explosion_impact(position)


func _on_AnimatedSprite_animation_finished():
    GlobalSignal.remove_emitter('explosion', self)
    queue_free()
