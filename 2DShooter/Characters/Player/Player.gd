extends BaseCharacter


onready var lookahead = $Lookahead
onready var weapon = $Top/Weapon
onready var camera = $Camera2D

export var max_dash_speed = 400
var dash_speed = 400
export var dash_duration = 0.3
var can_dash = true
var dashing = false

func get_input(delta):
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
        velocity = velocity.normalized() * dash_speed
    else:
        # Make sure diagonal movement isn't faster
        velocity = velocity.normalized() * speed

    top.look_at(get_global_mouse_position())


func dash():
    $DashTween.interpolate_property(self, 'dash_speed', speed, dash_speed,
        dash_duration, Tween.TRANS_BACK, Tween.EASE_OUT)
    $DashTween.start()
    can_dash = false
    dashing = true


func powerup(powerup):
    if powerup is WeaponResource:
        weapon.set_weapon(powerup)


func die():
    # current: reload scene
    # TODO: death screen
    get_tree().reload_current_scene()


func _on_Weapon_shot_fired(weapon_data):
    # get the direction opposite to the firing direction
    var direction = (global_position - get_global_mouse_position()).normalized()
    move_and_slide(direction * weapon_data.kickback)


func _on_DashCooldown_timeout():
    can_dash = true


func _on_DashInTween_tween_completed(object, key):
    dashing = false
    print('dash finished')
    print(speed)
    print(dash_speed)
    $DashCooldown.start()
