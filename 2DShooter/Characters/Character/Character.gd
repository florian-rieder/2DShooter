extends KinematicBody2D
class_name Character

onready var dust_particles = $DustParticles

export var health : int = 100
export var max_health : int = 100
export var speed : int = 100
var alive = true

export (PackedScene) var blood
export var blood_drops = 4

# movement
var velocity : Vector2 = Vector2.ZERO

export var kick_decay = 10
var kick_direction : Vector2 = Vector2.ZERO
var kick_speed = 0

var invulnerable = false


onready var top = $Top


func get_input(_delta):
    # Input control callback
    pass


func die():
    # Character death callback
    pass


func take_hit(damage, hit_direction):
    # prevents the die() function being fired multiple times in some cases    
    if not alive:
        return
    # obviously, don't take a hit if invulnerable
    if invulnerable:
        return
    bleed(hit_direction)
    # Take damage
    health -= damage
        # Flash white
    $EffectsPlayer.play("FlashWhite")

    if health <= 0:
        alive = false
        die()
        return

    kick_direction = hit_direction
    kick_speed = damage * 10

    # death condition
    
    custom_take_hit(damage, hit_direction)


func bleed(hit_direction) -> void:
    var root = get_tree().get_root()
    for _i in range(blood_drops):
        var blood_instance = blood.instance()
        blood_instance.global_position = global_position
        var blood_speed = Vector2(randf() * 3 * hit_direction.x, randf() * 3 * hit_direction.y)
        blood_instance.speed = blood_speed
        root.call_deferred("add_child", blood_instance)


func _physics_process(delta):
    # movement
    get_input(delta)
    move_and_slide(velocity + kick_direction * kick_speed)

    # footstep particles
    if velocity.length() > 10:
        dust_particles.emitting = true
    # kickback
    kick_speed -= kick_decay
    if kick_speed < 0:
        kick_speed = 0

# virtual function: implemented by descendents
func custom_take_hit(_damage, _hit_direction) -> void:
    pass
