extends HBoxContainer


func _ready():
    GlobalSignal.add_listener('money_changed', self, '_on_Player_money_changed')


func _on_Player_money_changed(value) -> void:
    $Money.text = str(value)
