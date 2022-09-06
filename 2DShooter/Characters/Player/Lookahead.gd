extends Node2D


export var distance = Vector2(100, 50) # different values on x and y axis
var kickback_vector = Vector2.ZERO
#var viewport_size = 

# Moves the camera focus in the direction the player is facing
func direction(direction, mouse_pos):
    # mouse_pos: position of the mouse relative to the player
    var movement_vector = direction * distance
    position = movement_vector/2 + mouse_pos/3 + kickback_vector
    kickback_vector = Vector2.ZERO


func _on_Weapon_shot_fired(kickback):
    var direction = (global_position - get_global_mouse_position()).normalized()
    kickback_vector = direction * kickback
