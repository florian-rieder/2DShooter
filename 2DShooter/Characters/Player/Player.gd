extends BaseCharacter


onready var lookahead = $Lookahead
onready var weapon = $Weapon


func get_input(_delta):
    if Input.is_action_pressed('right'):
        velocity.x += 1
    if Input.is_action_pressed('left'):
        velocity.x -= 1
    if Input.is_action_pressed('down'):
        velocity.y += 1
    if Input.is_action_pressed('up'):
        velocity.y -= 1

    # DEBUG
#    if Input.is_key_pressed(KEY_C):
#        $Camera2D.add_trauma(0.1)

    if Input.is_action_pressed('fire'):
            weapon.fire()

    # give the current direction to the camera focus
    lookahead.call('direction', velocity, get_local_mouse_position())
    # Make sure diagonal movement isn't faster
    velocity = velocity.normalized() * speed


func powerup(powerup):
    if powerup is WeaponResource:
        weapon.set_weapon(powerup)


func die():
    # current: reload scene
    # TODO: death screen
    get_tree().reload_current_scene()


func _on_Weapon_shot_fired(kickback, _shake_trauma):
    var direction = (global_position - get_global_mouse_position()).normalized()
    move_and_slide(direction * kickback)
