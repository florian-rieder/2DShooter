extends Control


export(NodePath) onready var weapons_grid = get_node(weapons_grid) as GridContainer
export(NodePath) onready var focused_weapon_texture_rect = get_node(focused_weapon_texture_rect) as TextureRect

export(PackedScene) var weapon_grid_button

var focused_weapon = null

func _ready() -> void:
    # fill the shop grid with all the weapons
    for weapon in GameManager.player_weapons:
        var button = weapon_grid_button.instance()
        button.icon = weapon.texture
        # bind the weapon id to the signal
        button.connect("pressed", self, "_on_WeaponButton_pressed", [weapon.id])
        weapons_grid.add_child(button)


func set_focused_weapon(id):
    focused_weapon = GameManager.find_player_weapon_by_id(id)
    focused_weapon_texture_rect.texture = focused_weapon.texture


func _on_WeaponButton_pressed(id):
    # here we have this id parameter because it's bound in the connect method in
    # _ready
    set_focused_weapon(id)


func _on_ExitButton_pressed():
    GameManager.next_level()


func _on_UpgradeButton_pressed():
    GameManager.upgrades["weapons"][focused_weapon.id]["damage"] += 0.1
    GameManager.money -= 1000
