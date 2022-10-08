extends KinematicBody2D

export(PackedScene) var Explosion
export(int) var max_health = 75
onready var health = max_health
export(int) var damage_states = 3


func _ready():
    visible = false


func take_hit(damage, _hit_direction):
    health -= damage

    var current_damage_state = 1
    for i in range(1, damage_states):
        if health < max_health / i:
            current_damage_state = i

    $Sprite.region_rect = Rect2(current_damage_state * 32, 0, 32, 32)

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
