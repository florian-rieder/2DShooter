extends Character
class_name Enemy

signal enemy_died(Enemy)

# State machine AI
onready var state_machine = $StateMachine
onready var left_ray = $LeftRay
onready var right_ray = $RightRay

onready var target = get_tree().get_nodes_in_group('Player')[0]
var direction = Vector2.ZERO
export (PackedScene) var powerup
export (Resource) var health_pack
export var health_drop_probability = 0.03

export var max_money_drop = 10

func _ready():
    visible = false

func get_input(_delta):
    top.look_at(target.global_position)


func die():
    GameManager.money += randi() % max_money_drop
    if target.health < target.max_health / 2 and randf() < health_drop_probability:
        drop_health()
    emit_signal('enemy_died', self)
    queue_free()


func drop_health() -> void:
    var instance = powerup.instance()
    instance.set_powerup(health_pack)
    instance.global_position = global_position
    get_tree().get_root().call_deferred('add_child', instance)


func _on_VisibilityEnabler2D_screen_exited():
    visible = false


func _on_VisibilityEnabler2D_screen_entered():
    visible = true
