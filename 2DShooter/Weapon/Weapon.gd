extends Node2D

signal shot_fired

export (Resource) var weapon setget set_weapon, get_weapon
export (PackedScene) var projectile_scene

onready var muzzle = $Muzzle
onready var _root = get_tree().get_root()
# rate of fire = shots / minute = r/m
# x = seconds / shot = s/r
# r/m = n
# x = 60/(r/m) = s/r
onready var _seconds_per_shot = 60.0 / weapon.rate_of_fire # the casting is important
var _time_since_last_shot = 0


func _physics_process(delta):
    # align weapon with mouse
    look_at(get_global_mouse_position())
    _time_since_last_shot += delta


func fire():
    # check if we can fire
    if not can_fire():
        return

    # spawns a projectile in the direction the muzzle is pointing
    for angle in weapon.projectile_angles:
        spawn_projectile(angle)

    # emit feedback
    emit_signal('shot_fired', weapon)
    play_fire_sound()


func can_fire():
    # check fire rate
    # check if enough time passed since last shot
    if _time_since_last_shot < _seconds_per_shot:
        return false
    # if enough time has passed, reset counter
    _time_since_last_shot = 0
    return true


func spawn_projectile(deviation = 0.0):
    var inac = weapon.inaccuracy/2 # inaccuracy
    var random_deviation = rand_range(-inac, inac)
    var b = projectile_scene.instance()
    b.projectile = weapon.projectile
    owner.add_child(b)
    b.global_transform = muzzle.global_transform
    # inaccuracy and deviation
    b.set_rotation(b.rotation + deviation + random_deviation)


func play_fire_sound():
    # To avoid the sound from clipping, we generate a new
    # audio node each time then we delete it
    var audio_node = AudioStreamPlayer.new()
    var pick_sound = randi() % weapon.fire_sounds.size() # Pick a random sound
    audio_node.stream = weapon.fire_sounds[pick_sound]
    audio_node.pitch_scale = rand_range(0.95, 1.05)
    audio_node.bus = "SFX"
    _root.add_child(audio_node)
    audio_node.play()
    audio_node.connect("finished", audio_node, "queue_free")


func get_weapon() -> WeaponResource:
    return weapon


func set_weapon(new_weapon):
    weapon = new_weapon
    # set new fire rate
    _seconds_per_shot = 60.0 / weapon.rate_of_fire # the casting is important
