extends KinematicBody2D

export (PackedScene) var Explosion
var health = 10


func _ready():
    visible = false


func take_hit(damage, _hit_direction):
    health -= damage
    if health <= 0:
        die()


func die():
    # don't explode offscreen, that's not cool
    if not visible:
        return
    var boom = Explosion.instance()
    boom.global_position = global_position
    get_tree().get_root().call_deferred('add_child', boom)
    queue_free()


func _on_VisibilityNotifier2D_screen_entered():
    visible = true


func _on_VisibilityNotifier2D_screen_exited():
    visible = false
