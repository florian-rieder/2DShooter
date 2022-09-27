extends State


func enter(_msg := {}) -> void:
    owner.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
    owner.weapon.fire()
