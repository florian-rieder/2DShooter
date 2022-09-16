extends StaticBody2D

export (PackedScene) var explosion
var health = 10

var is_on_screen = false


func take_hit(damage, _hit_direction):
    health -= damage
    if health <= 0:
        die()


func die():
    if not is_on_screen:
        return
    var boom = explosion.instance()
    boom.global_position = global_position
    get_tree().get_root().call_deferred('add_child', boom)
    queue_free()


func _on_VisibilityNotifier2D_screen_entered():
    is_on_screen = true


func _on_VisibilityNotifier2D_screen_exited():
    is_on_screen = false
