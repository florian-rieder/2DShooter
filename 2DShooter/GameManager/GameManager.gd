extends Node

signal money_changed(money)

export (Array, PackedScene) var arena_scenes = Array()
export (PackedScene) var shop_scene
export var shop_probability : float = 0.3

var money = 0 setget set_money, get_money


var last_level = null
onready var current_level = get_tree().current_scene

func _ready() -> void:
    GlobalSignal.add_emitter('money_changed', self)


func next_level() -> void:
    var next_level = choose_next_level()
    last_level = current_level
    current_level = next_level
    get_tree().change_scene_to(next_level)


func choose_next_level():
    if last_level != shop_scene and randf() < shop_probability:
        return shop_scene
    else:
        return arena_scenes[rand_range(0, len(arena_scenes) - 1)]

func set_money(value):
    money = value
    emit_signal('money_changed', money)

func get_money():
    return money
