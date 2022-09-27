extends Node2D

onready var healthbar = $Progress

var bar_green = preload("res://UI/HealthBar/Progress.png")
var bar_red = preload("res://UI/HealthBar/ProgressRed.png")

func _ready():
    hide()


func set_max_value(max_value):
    healthbar.max_value = max_value


func update_bar(value):
    if value >= healthbar.max_value:
        hide()
        return
    healthbar.texture_progress = bar_green
    if value < healthbar.max_value * 0.35:
        healthbar.texture_progress = bar_red
    if value < healthbar.max_value:
        show()
    healthbar.value = value
