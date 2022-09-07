extends Node2D


func _ready():
    $ImpactParticles.emitting = true
    $ImpactSprite.playing = true

# destroy this node when the animation is finished
func _on_ImpactSprite_animation_finished():
    # wait 1 sec to make sure particles are done
    queue_free()
