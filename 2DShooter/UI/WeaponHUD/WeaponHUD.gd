extends Control


func _ready() -> void:
    GlobalSignal.add_listener("weapon_changed", self, "_on_Player_changed_weapon")


func update_display(icon, text):
    $Icon.texture = icon
    $Name.text = text


func _on_Player_changed_weapon(weapon : WeaponResource):
    update_display(weapon.texture, weapon.name)
