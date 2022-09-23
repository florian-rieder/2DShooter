extends Node2D


export var distance = Vector2(50, 50) # different values on x and y axis
var kickback_vector = Vector2.ZERO
export var mouse_divider : float = 2.5 # divides mouse coordinates

# Moves the camera focus in the direction the player is facing
func direction(direction, mouse_pos):
    # mouse_pos: position of the mouse relative to the player
    var movement_vector = direction.normalized() * distance
    position = movement_vector + mouse_pos / mouse_divider + kickback_vector
    kickback_vector = Vector2.ZERO


func _on_Weapon_shot_fired(kickback):
    # get kickback direction: opposite to where we're aiming
    var direction = (global_position - get_global_mouse_position()).normalized()
    kickback_vector = direction * kickback
