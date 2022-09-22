extends Character

# Component references
onready var lookahead = $Lookahead
onready var weapon = $Top/Weapon
onready var camera = $Camera2D
# dash
export var dash_duration = 0.3
export var dash_speed = 400
var current_dash_speed = 0
var can_dash = true
var dashing = false
# invulnerability
export var invulnerability_duration = 1.0


func get_input(_delta):
    velocity = Vector2.ZERO
    if Input.is_action_pressed('right'):
        velocity.x += 1
    if Input.is_action_pressed('left'):
        velocity.x -= 1
    if Input.is_action_pressed('down'):
        velocity.y += 1
    if Input.is_action_pressed('up'):
        velocity.y -= 1

    # DEBUG
    if Input.is_key_pressed(KEY_C):
        camera.add_trauma(0.1)

    if Input.is_action_pressed('fire'):
        weapon.fire()
    
    if can_dash and Input.is_action_pressed("dash"):
        dash()

    # give the current direction to the camera focus
    lookahead.call('direction', velocity, get_local_mouse_position())
    
    if dashing:
        velocity = velocity.normalized() * current_dash_speed
    else:
        # Make sure diagonal movement isn't faster
        velocity = velocity.normalized() * speed

    top.look_at(get_global_mouse_position())


func dash():
    $DashTween.interpolate_property(self, 'current_dash_speed', speed, dash_speed,
        dash_duration, Tween.TRANS_BACK, Tween.EASE_OUT)
    $DashTween.start()
    can_dash = false
    dashing = true


func powerup(powerup):
    if powerup is WeaponResource:
        weapon.set_weapon(powerup)


func custom_take_hit(_damage, _hit_direction) -> void:
    camera.add_trauma(0.3)
    # greater kick speed on the player
    kick_speed = kick_speed * 2
    # freeze for a short amount of time
    freeze_frame(0.2, 0.3)
    # invulnerability
    $Invulnerability.start(invulnerability_duration)
    invulnerable = true
    modulate.a = 0.8


func die():
    # current: reload scene
    # TODO: death screen
    Engine.time_scale = 1.0
    get_tree().reload_current_scene()


func freeze_frame(time_scale : float, duration : float):
    Engine.time_scale = time_scale
    yield(get_tree().create_timer(duration * time_scale), "timeout")
    Engine.time_scale = 1.0


func _on_Weapon_shot_fired(weapon_data):
    # get the direction opposite to the firing direction
    kick_direction = (global_position - get_global_mouse_position()).normalized()
    kick_speed = weapon_data.kickback


func _on_DashCooldown_timeout():
    can_dash = true


func _on_DashInTween_tween_completed(_object, _key):
    dashing = false
    $DashCooldown.start()


func _on_Invulnerability_timeout():
    invulnerable = false
    modulate.a = 1
