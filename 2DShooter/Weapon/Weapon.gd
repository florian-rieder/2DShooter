extends Node2D

signal shot_fired

export (Resource) var weapon

onready var muzzle = $Muzzle
onready var _root = get_tree().get_root()

# rate of fire = shots / minute = r/m
# x = seconds / shot = s/r
# r/m = n
# x = 60/(r/m) = s/r
var _seconds_per_shot = 1
var _time_since_last_shot = 0


func _ready():
    _seconds_per_shot = 60.0 / weapon.rate_of_fire # the casting is important


func _physics_process(delta):
    # align weapon with mouse
    look_at(get_global_mouse_position())
    _time_since_last_shot += delta

func update_weapon(new_weapon):
    weapon = new_weapon
    # set new fire rate
    _seconds_per_shot = 60.0 / weapon.rate_of_fire # the casting is important
    

func fire():
    # check fire rate
    if _time_since_last_shot < _seconds_per_shot:
        return
    _time_since_last_shot = 0

    # spawns a projectile in the direction the muzzle is pointing
    var b = weapon.projectile.instance()
    owner.add_child(b)
    b.global_transform = muzzle.global_transform
    # inaccuracy
    b.set_rotation(b.rotation + rand_range(-weapon.inaccuracy, weapon.inaccuracy))
    play_fire_sound()
    emit_signal('shot_fired', weapon.kickback, weapon.shake_trauma)


func play_fire_sound():
    # To avoid the sound from clipping, we generate a new
    # audio node each time then we delete it
    var audio_node = AudioStreamPlayer.new()
    var pick_sound = randi() % weapon.fire_sounds.size() # Pick a random sound
    audio_node.stream = weapon.fire_sounds[pick_sound]
    audio_node.pitch_scale = rand_range(0.95, 1.05)
    _root.add_child(audio_node)
    audio_node.play()
    yield(get_tree().create_timer(2), "timeout")
    audio_node.queue_free()
