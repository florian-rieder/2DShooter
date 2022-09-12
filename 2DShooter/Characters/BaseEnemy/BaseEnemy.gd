extends BaseCharacter
class_name BaseEnemy

# State machine AI
onready var state_machine = $StateMachine

var target = null
var direction = Vector2.ZERO

var asleep := true
var on_screen := false
var sleep_timeout := 5 # seconds
var sleep_timer := 0.0


func get_input(delta):
    # sleep after a few seconds off-screen
    if not on_screen and not asleep:
        sleep_timer += delta
        if sleep_timer >= sleep_timeout:
            asleep = true
            state_machine.transition_to('Asleep')

    if asleep:
        return

    if target:
        state_machine.transition_to('Chase')
    else:
        state_machine.transition_to('Wander')


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


func _on_VisibilityEnabler2D_screen_exited():
    on_screen = false


func _on_VisibilityEnabler2D_screen_entered():
    on_screen = true
    asleep = false
    sleep_timer = 0.0
