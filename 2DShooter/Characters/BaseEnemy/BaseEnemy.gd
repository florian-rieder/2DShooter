extends BaseCharacter
class_name BaseEnemy


onready var noise = OpenSimplexNoise.new()
var noise_y = 0
var target
var direction


func _ready():
    noise.seed = randi()
    noise.period = 4
    noise.octaves = 2


func get_input(delta):
    if target:
        chase()
    else:
        wander(delta)

    if direction.x < 0:
        # flip on x axis
        scale.x = -1
    else:
        scale.x = 1


func wander(delta):
    var x = noise.get_noise_2d(noise.seed, noise_y)
    var y = noise.get_noise_2d(noise.seed * 2, noise_y)
    noise_y += delta
    direction = Vector2(x, y).normalized()
    velocity = direction * speed / 2


func chase():
    # move in the direction of the target
    direction = position.direction_to(target.position)
    direction = direction.normalized()
    velocity = direction * speed


func die():
    queue_free()


func _on_DetectionArea_body_entered(body):
    # follow the target
    if "Player" in body.get_groups():
        target = body


func _on_DetectionArea_body_exited(body):
    # stop following the target
    if body == target:
        target = null
