extends State

# Wander behavior

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    owner.velocity = Vector2.ZERO
    var x = rand_range(-1, 1)
    var y = rand_range(-1, 1)
    #var body_rotation = deg2rad(owner.top.rotation
    owner.direction = Vector2(x, y).normalized()
#    if owner.left_ray.is_colliding():
#        owner.direction += Vector2(0, 1).rotated(body_rotation)
#    if owner.right_ray.is_colliding():
#        owner.direction += Vector2(0, -1).rotated(body_rotation)
    owner.velocity = owner.direction * owner.speed / 2
