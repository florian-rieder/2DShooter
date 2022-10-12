extends Node2D


export(Vector2) var distance = Vector2(50, 50) # different values on x and y axis
export(float) var mouse_divider = 2.5 # divides mouse coordinates
export(float, 0, 0.999) var kickback_decay = 0.7
var kickback_vector = Vector2.ZERO
var position_vector = Vector2.ZERO

func _process(delta):
        position = position_vector
        # reset the position vector: when direction is not called that frame,
        # the lookahead will go back to the center (notably on arena cleared)
        position_vector = Vector2.ZERO

# Moves the camera focus in the direction the player is facing
func direction(direction, mouse_pos):
    # mouse_pos: position of the mouse relative to the player
    var movement_vector = direction.normalized() * distance
    position_vector = movement_vector + mouse_pos / mouse_divider + kickback_vector
    kickback_vector *= kickback_decay


func _on_Weapon_shot_fired(kickback):
    # get kickback direction: opposite to where we're aiming
    var direction = (global_position - get_global_mouse_position()).normalized()
    kickback_vector = direction * kickback
