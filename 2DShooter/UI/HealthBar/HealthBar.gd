# simple health bar using ProgressTexture.
# allows "last stand" mechanic: the last pixel has more health
extends Node2D

onready var healthbar = $Progress

var bar_green = preload("res://UI/HealthBar/Progress.png")
var bar_red = preload("res://UI/HealthBar/ProgressRed.png")

# percentage at which the healthbar turns red
var red_percent_threshold = 0.4
# health level at which the healthbar will display 1px
export var last_stand_threshold = 0


func _ready():
    hide()


func set_max_value(max_value):
    healthbar.max_value = max_value - last_stand_threshold


func update_bar(value):
    var adjusted_value = value - last_stand_threshold
    # hide the healthbar if full
    if adjusted_value >= healthbar.max_value:
        hide()
        return
    # change color in function of value
    healthbar.texture_progress = bar_green
    if adjusted_value < healthbar.max_value * red_percent_threshold:
        healthbar.texture_progress = bar_red
    # show the healthbar if not full
    if adjusted_value < healthbar.max_value:
        show()
    # change the value
    if adjusted_value < 1:
        healthbar.value = 1
    else:
        healthbar.value = adjusted_value
