extends Area2D

class_name Powerup

export (Resource) var powerup setget set_powerup

onready var sprite = $Sprite
var offset_delta = 0
var oscillation_amplitude = 5
var oscillation_speed_scale = 4


func _ready():
    sprite.texture = powerup.texture


func _process(delta):
    # make the sprite oscillate up and down
    sprite.offset.y = sin(offset_delta * oscillation_speed_scale) * oscillation_amplitude
    offset_delta += delta


func set_powerup(new_powerup):
    powerup = new_powerup
    if sprite:
        sprite.texture = powerup.texture


func _on_Powerup_body_entered(body):
    if powerup == null:
        print('NO POWERUP ATTACHED')
        return
    if "Player" in body.get_groups():
        body.call('powerup', powerup)
        # TODO: spawn an animation
        queue_free()
