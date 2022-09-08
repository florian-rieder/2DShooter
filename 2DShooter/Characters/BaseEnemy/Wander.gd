extends State

# Wander behavior

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    owner.velocity = Vector2.ZERO
    var x = rand_range(-1, 1)
    var y = rand_range(-1, 1)
    owner.direction = Vector2(x, y).normalized()
    owner.velocity = owner.direction * owner.speed / 2
