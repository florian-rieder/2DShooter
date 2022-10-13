extends Control

export (NodePath) onready var kills_label = get_node(kills_label)
export (NodePath) onready var specials_label = get_node(specials_label)


func _ready() -> void:
    GlobalSignal.add_listener("arena_cleared", self, "_on_Arena_cleared")
    $ConfettiCannonLeft/ConfettiCannon.emitting = true
    $ConfettiCannonRight/ConfettiCannon.emitting = true


func _on_Arena_cleared(kills):
    # update kill count labels    
    kills_label.text = str(kills)
    visible = true


func _on_Continue_pressed():
    GameManager.next_level()


func _on_Menu_pressed():
    pass # Replace with function body.
