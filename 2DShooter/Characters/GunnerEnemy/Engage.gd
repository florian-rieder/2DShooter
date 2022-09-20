extends State


func enter(_msg := {}) -> void:
    owner.velocity = Vector2.ZERO

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
    owner.weapon.fire()
