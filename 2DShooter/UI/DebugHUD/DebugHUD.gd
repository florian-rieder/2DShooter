extends Control


export (NodePath) onready var fps = get_node(fps) as Label
export (NodePath) onready var enemies = get_node(enemies) as Label
export (NodePath) onready var kills = get_node(kills) as Label


func _physics_process(_delta):
    fps.text = str(Engine.get_frames_per_second())
    enemies.text = str(len(get_tree().get_nodes_in_group('Enemy')))
