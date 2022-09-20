extends Character
class_name Enemy

# State machine AI
onready var state_machine = $StateMachine

onready var left_ray = $LeftRay
onready var right_ray = $RightRay

var arena = null

onready var target = get_tree().get_nodes_in_group('Player')[0]
var direction = Vector2.ZERO
var on_screen := false


func get_input(delta):
    top.look_at(target.global_position)


func die():
    if arena:
        arena.enemy_died(self)
    queue_free()


func _on_VisibilityEnabler2D_screen_exited():
    on_screen = false


func _on_VisibilityEnabler2D_screen_entered():
    on_screen = true
