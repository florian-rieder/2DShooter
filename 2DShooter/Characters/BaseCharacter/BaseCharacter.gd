extends KinematicBody2D
class_name BaseCharacter


export var health : int = 100
export var speed : int = 100

var velocity : Vector2 = Vector2.ZERO


func get_input(_delta):
    # Input control callback
    pass


func die():
    # Character death callback
    pass


func take_hit(damage):
    health -= damage
    $AnimationPlayer.play("FlashWhite")
    if health <= 0:
        die()


func _physics_process(delta):
    velocity = Vector2.ZERO
    get_input(delta)
    velocity = move_and_slide(velocity)
