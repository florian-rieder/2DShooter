extends State

# Chase Behavior

func physics_update(_delta: float) -> void:
    # move in the direction of the target
    owner.velocity = Vector2.ZERO
    owner.direction = owner.global_position.direction_to(owner.target.global_position).normalized()    
    owner.velocity = owner.direction * owner.speed
