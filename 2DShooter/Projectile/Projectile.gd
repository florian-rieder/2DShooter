extends Area2D


export (Resource) var projectile
onready var _root = get_tree().get_root()

var moving = true

func _physics_process(delta):
    if not moving:
        return
    position += transform.x * projectile.speed * delta


func _on_Projectile_body_entered(body):
    if body.has_method('take_hit'):
        body.call('take_hit', projectile.damage)
    play_hit_sound()
    spawn_impact()
    queue_free()

func spawn_impact():
    var root = get_tree().get_root()
    for _i in range(projectile.impact_quantity):
        var impact = projectile.impact.instance()

        var deviation = Vector2.ZERO
        if projectile.impact_deviation != 0:
            deviation = Vector2(randi() % projectile.impact_deviation, randi() % projectile.impact_deviation)

        root.add_child(impact)
        impact.global_position = global_position + deviation


func play_hit_sound(): # To avoid the sound from clipping, we generate a new audio node each time then we delete it
    var audio_node = AudioStreamPlayer.new()
    var pick_sound = randi() % projectile.impact_sounds.size() # Pick a random sound
    audio_node.stream = projectile.impact_sounds[pick_sound]
    audio_node.pitch_scale = rand_range(0.95, 1.05)
    audio_node.bus = "SFX"
    _root.add_child(audio_node)
    audio_node.play()
    # destroy the node when the sound is finished playing
    audio_node.connect("finished", audio_node, "queue_free")


func _on_Timer_timeout():
    # destroy the projectile after a while
    queue_free()
