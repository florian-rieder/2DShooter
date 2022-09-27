extends State


func physics_update(_delta: float) -> void:
    # move in the direction of the target
    owner.velocity = Vector2.ZERO
    owner.direction = owner.target.global_position.direction_to(owner.global_position).normalized()    
    owner.velocity = owner.direction * owner.speed
