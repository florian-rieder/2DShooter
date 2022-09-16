extends KinematicBody2D
class_name BaseCharacter


export var health : int = 100
export var speed : int = 100
export (PackedScene) var blood

var velocity : Vector2 = Vector2.ZERO
var alive = true

onready var top = $Top


func get_input(_delta):
    # Input control callback
    pass


func die():
    # Character death callback
    pass


func take_hit(damage):
    if not alive:
        # prevents the die() function being fired multiple times in some cases
        return

    health -= damage
    $AnimationPlayer.play("FlashWhite")

    var root = get_tree().get_root()
    for _i in range(8):
        var blood_instance = blood.instance()
        blood_instance.global_position = global_position
        root.call_deferred("add_child", blood_instance)

    if health <= 0:
        alive = false
        die()


func _physics_process(delta):
    get_input(delta)
    velocity = move_and_slide(velocity)
    if velocity.length() > 10:
        $DustParticles.emitting = true
