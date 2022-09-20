extends Enemy
class_name GunnerEnemy

onready var weapon = $Top/Weapon


func _on_FireRange_body_entered(body):
    if body.is_in_group('Player'):
        state_machine.transition_to('Engage')


func _on_FireRange_body_exited(body):
    if body.is_in_group('Player'):
        state_machine.transition_to('Chase')


func _on_Weapon_shot_fired(weapon_data):
    kick_direction = -direction.normalized()
    kick_speed = weapon_data.kickback
