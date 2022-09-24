extends Character
class_name Enemy

signal enemy_died(Enemy)

# State machine AI
onready var state_machine = $StateMachine
onready var left_ray = $LeftRay
onready var right_ray = $RightRay

onready var target = get_tree().get_nodes_in_group('Player')[0]
var direction = Vector2.ZERO
var on_screen := false
export (PackedScene) var powerup
export (Resource) var health_pack
export var health_drop_probability = 0.02


func get_input(_delta):
    top.look_at(target.global_position)


func die():
    emit_signal('enemy_died', self)
    if randf() < health_drop_probability:
        drop_health()
    queue_free()

func drop_health() -> void:
    var instance = powerup.instance()
    instance.set_powerup(health_pack)
    instance.global_position = global_position
    get_tree().get_root().add_child(instance)


func _on_VisibilityEnabler2D_screen_exited():
    on_screen = false


func _on_VisibilityEnabler2D_screen_entered():
    on_screen = true
