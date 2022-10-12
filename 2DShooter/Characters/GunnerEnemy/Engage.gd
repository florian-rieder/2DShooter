extends State

export(bool) var burst_behavior = false
export(float) var burst_cooldown = 0.0
export(float) var burst_duration = 0.0

var burst_firing = false

onready var burst_cooldown_timer = $BurstCooldown as Timer
onready var burst_duration_timer = $BurstDuration as Timer


func enter(_msg := {}) -> void:
    owner.velocity = Vector2.ZERO

    if burst_behavior:
        start_burst()


func exit() -> void:
    # when state is left
    if burst_behavior:
        burst_cooldown_timer.stop()
        burst_duration_timer.stop()


func physics_update(_delta: float) -> void:
    # limit firing when in burst mode to when burst_firing flag is true
    if burst_behavior and not burst_firing:
        return

    owner.weapon.fire()


func _on_BurstCooldown_timeout():
    start_burst()


func start_burst() -> void:
    burst_duration_timer.start(burst_duration)
    burst_firing = true


func _on_BurstDuration_timeout():
    stop_burst()


func stop_burst() -> void:
    burst_cooldown_timer.start(burst_cooldown)
    burst_firing = false
