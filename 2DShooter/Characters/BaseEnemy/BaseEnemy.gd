extends BaseCharacter
class_name BaseEnemy


onready var state_machine = $StateMachine
var noise_y = 0
var target = null
var direction = Vector2.ZERO


func get_input(_delta):
    if target:
        state_machine.transition_to('Chase')
    else:
        state_machine.transition_to('Wander')

    if direction.x < 0:
        # flip on x axis (Maybe, really can't tell)
        scale.x = -1
    else:
        scale.x = 1


func die():
    queue_free()


func _on_DetectionArea_body_entered(body):
    # follow the target
    if "Player" in body.get_groups():
        target = body


func _on_DetectionArea_body_exited(body):
    # stop following the target
    if body == target:
        target = null
