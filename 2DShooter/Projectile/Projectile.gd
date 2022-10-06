extends Area2D


export (Resource) var projectile
onready var _root = get_tree().get_root()

var hits = 0
var speed_malus = 0
var min_speed = 400

var damage_modifier = 0


func _ready():
    $Sprite.frames = projectile.frames
    visible = false


func _physics_process(delta):
    var speed = projectile.speed - speed_malus
    position += transform.x * speed * delta


func _on_Projectile_body_entered(body):
    
    if projectile.avoid_enemies and body.is_in_group('Enemy'):
        return
    # inflict damage
    if body.has_method('take_hit'):
        var hit_direction = Vector2.RIGHT.rotated(rotation)
        var damage = projectile.damage * (1 + damage_modifier)
        body.call('take_hit', damage, hit_direction)

    # feedback
    play_hit_sound()
    spawn_impact()

    # if the projectile hits its max amount of hits (piercing projectiles)
    if hits == projectile.piercing:
        queue_free()
    speed_malus += projectile.pierce_speed_loss
    # destroy the projectile if it travels too slow
    if projectile.speed - speed_malus < min_speed:
        queue_free()

    hits += 1


func spawn_impact():
    var root = get_tree().get_root()
    for _i in range(projectile.impact_quantity):
        var impact = projectile.impact.instance()

        var deviation = Vector2.ZERO
        if projectile.impact_deviation != 0:
            deviation = Vector2(randi() % projectile.impact_deviation, randi() % projectile.impact_deviation)

        root.call_deferred('add_child', impact)
        impact.global_position = global_position + deviation


func play_hit_sound(): # To avoid the sound from clipping, we generate a new audio node each time then we delete it
    var audio_node = AudioStreamPlayer2D.new()
    var pick_sound = randi() % projectile.impact_sounds.size() # Pick a random sound
    audio_node.stream = projectile.impact_sounds[pick_sound]
    audio_node.volume_db = -10
    audio_node.pitch_scale = rand_range(0.95, 1.05)
    audio_node.bus = "SFX"
    audio_node.global_position = global_position
    _root.add_child(audio_node)
    audio_node.play()
    # destroy the node when the sound is finished playing
    audio_node.connect("finished", audio_node, "queue_free")


func _on_Timer_timeout():
    # destroy the projectile after a while
    queue_free()


func _on_VisibilityEnabler2D_screen_entered():
    visible = true


func _on_VisibilityEnabler2D_screen_exited():
    visible = false
