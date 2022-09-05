extends Area2D


export (Resource) var projectile

#var inaccuracy = 90
#var impact_deviation = 16
#var impact_quantity = 5

onready var _root = get_tree().get_root()


func _physics_process(delta):
    position += transform.x * projectile.speed * delta


func _on_Projectile_body_entered(body):
    $Sprite.visible = false
    $CollisionShape2D.disabled = true
    $Timer.start()
    play_hit_sound()
    spawn_impact()
    if body.has_method('take_hit'):
        body.call('take_hit', projectile.damage)
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
    _root.add_child(audio_node)
    audio_node.play()
    yield(get_tree().create_timer(2), "timeout")
    audio_node.queue_free()


func _on_Timer_timeout():
    # destroy the projectile after a while
    queue_free()
