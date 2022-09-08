extends StaticBody2D

export (PackedScene) var explosion
var health = 10

func take_hit(damage):
    health -= damage
    if health <= 0:
        die()
    
func die():
    var boom = explosion.instance()
    boom.global_position = global_position
    get_tree().get_root().add_child(boom)
    queue_free()
