extends Character
class_name Enemy

# State machine AI
onready var state_machine = $StateMachine

onready var left_ray = $LeftRay
onready var right_ray = $RightRay

var arena = null

onready var target = get_tree().get_nodes_in_group('Player')[0]
var direction = Vector2.ZERO
# sleep
var asleep := false
var on_screen := false
var sleep_timeout := 10 # seconds
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

    state_machine.transition_to('Chase')


func die():
    if arena:
        arena.enemy_died(self)
    queue_free()


func _on_VisibilityEnabler2D_screen_exited():
    on_screen = false


func _on_VisibilityEnabler2D_screen_entered():
    on_screen = true
    asleep = false
    sleep_timer = 0.0
