extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    GlobalSignal.add_listener('money_changed', self, '_on_Player_money_changed')


func _on_Player_money_changed(value) -> void:
    $Money.text = str(value)
