extends State

# Chase Behavior

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    if not owner.target:
        state_machine.transition_to('Wander')
        return

    # move in the direction of the target
    owner.velocity = Vector2.ZERO
    owner.direction = owner.global_position.direction_to(owner.target.global_position)
    owner.direction = owner.direction.normalized()
    owner.velocity = owner.direction * owner.speed
    owner.top.look_at(owner.target.position)
