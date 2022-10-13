extends HBoxContainer


func _ready():
    $Money.text = str(GameManager.money)
    GlobalSignal.add_listener('money_changed', self, '_on_Player_money_changed')
    GlobalSignal.add_listener("arena_cleared", self, "_on_Arena_cleared")

func _on_Player_money_changed(value) -> void:
    $Money.text = str(value)

func _on_Arena_cleared(_kills):
    visible = false
