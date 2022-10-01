extends Node

export (Array, PackedScene) var arena_scenes = Array()
export (PackedScene) var shop_scene
export var shop_probability : float = 0.3


var last_level = null
onready var current_level = get_tree().current_scene


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


