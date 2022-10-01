extends Node2D

onready var healthbar = $Progress

var bar_green = preload("res://UI/HealthBar/Progress.png")
var bar_red = preload("res://UI/HealthBar/ProgressRed.png")

var red_percent_threshold = 0.4
export var last_stand_threshold = 0

func _ready():
    hide()


func set_max_value(max_value):
    healthbar.max_value = max_value


func update_bar(value):
    if value >= healthbar.max_value:
        hide()
        return
    healthbar.texture_progress = bar_green
    if value < (healthbar.max_value) * red_percent_threshold:
        healthbar.texture_progress = bar_red
    if value < healthbar.max_value:
        show()
    
    if value < last_stand_threshold:
        healthbar.value = 5
    else:
        healthbar.value = value
