extends Camera2D
class_name ShakeCamera2D


export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) onready var target = get_node(target)  # Assign the node this camera will follow.

onready var noise = OpenSimplexNoise.new()
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var noise_y = 0
export var speed = 100


func _ready() -> void:
    randomize()
    noise.seed = randi()
    noise.period = 4
    noise.octaves = 2


func _process(delta) -> void:
    if target:
        # We subtract the camera offset in order to avoid the screenshake
        # moving the mouse, which then moves the lookahead, which then moves
        # the camera.
        # This feedback loop, which creates an ugly stutter, is avoided by
        # substracting the camera offset from the target position. That way,
        # the lookahead is offset in the opposite direction of the camera
        # offset, making it immobile relative to the world.
        # position = lerp(position, target.position, speed * delta)
        global_position = lerp(global_position, target.global_position - offset, speed * delta)
    if trauma:
        trauma = max(trauma - decay * delta, 0)
        shake()


func shake() -> void:
    var amount = pow(trauma, trauma_power)
    noise_y += 1
    # Using noise
    rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
    offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
    offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
    # Pure randomness
#	rotation = max_roll * amount * rand_range(-1, 1)
#	offset.x = max_offset.x * amount * rand_range(-1, 1)
#	offset.y = max_offset.y * amount * rand_range(-1, 1)


func add_trauma(amount) -> void:
    trauma = min(trauma + amount, 1.0)


func _on_Weapon_shot_fired(weapon: WeaponResource) -> void:
    if trauma < weapon.max_trauma:
        add_trauma(weapon.shake_trauma)

func _on_Explosion(shake_trauma):
    add_trauma(shake_trauma)
