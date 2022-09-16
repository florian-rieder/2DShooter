extends Area2D

class_name Powerup

export (Resource) var powerup

onready var sprite = $Sprite
var offset_delta = 0
export var oscillation_amplitude = 5
export var oscillation_speed_scale = 4

func _process(delta):
    # make the sprite oscillate up and down
    sprite.offset.y = sin(offset_delta * oscillation_speed_scale) * oscillation_amplitude
    offset_delta += delta


func _on_Powerup_body_entered(body):
    if powerup == null:
        print('NO POWERUP ATTACHED')
        return
    if "Player" in body.get_groups():
        body.call('powerup', powerup)
        queue_free()
