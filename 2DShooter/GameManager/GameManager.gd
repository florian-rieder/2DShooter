extends Node

signal money_changed(money)

# level management stuff
var last_level = null
onready var current_level = get_tree().current_scene
export (Array, PackedScene) var arena_scenes = Array()
export (PackedScene) var shop_scene
export var shop_probability : float = 0.3

# progression stuff
var money = 10_000 setget set_money, get_money

# all weapons the player can use and upgrade
export(Array, Resource) var player_weapons

# haven't found a better way yet.
# this will do for now
onready var upgrades = {
    "max_health": 0.0,
    "speed": 0.0,
    "dash_speed": 0.0,
    "dash_cooldown": 0.0,
    "weapons": {} # populated in _ready()
   }


func _ready() -> void:
    GlobalSignal.add_emitter('money_changed', self)

    # generate upgrade dictionaries for each weapon
    for weapon in player_weapons:
        upgrades["weapons"][weapon.id] = {
            "rate_of_fire" : 0,
            "spread" : 0,
            "damage" : 0,
        }


func next_level() -> void:
    Surface.reset()
    var next_level = choose_next_level()
    last_level = current_level
    current_level = next_level
    get_tree().change_scene_to(next_level)


func choose_next_level():
    if current_level != shop_scene and randf() < shop_probability:
        return shop_scene
    else:
        return arena_scenes[rand_range(0, len(arena_scenes) - 1)]


func set_money(value):
    money = value
    emit_signal('money_changed', money)


func get_money():
    return money


func find_player_weapon_by_id(id):
    for weapon in player_weapons:
        if weapon.id == id:
            return weapon
