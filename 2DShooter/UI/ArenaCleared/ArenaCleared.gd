extends Control

export (NodePath) onready var kills_label = get_node(kills_label)
export (NodePath) onready var specials_label = get_node(specials_label)


func update_labels(data : Dictionary) -> void:
    # update kill count labels
    kills_label.text = data.kills
    specials_label.text = data.specials


func _on_Continue_pressed():
    pass # Replace with function body.


func _on_Menu_pressed():
    pass # Replace with function body.
