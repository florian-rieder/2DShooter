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

export var max_kick = 200
export var kick_decay = 10
var kick_direction : Vector2 = Vector2.ZERO
var kick_speed = 0

export var invulnerable = false


onready var top = $Top


func get_input(_delta):
    # Input control callback
    pass


func die():
    # Character death callback
    pass


func take_hit(damage, hit_direction):
    # prevents the die() function being fired multiple times in some cases    
    if not alive or invulnerable:
        return

    bleed(hit_direction)

    # Take damage
    health -= damage
    # death condition
    if health <= 0:
        alive = false
        die()
        return

    $EffectsPlayer.play("FlashWhite")

    kick_direction = hit_direction
    kick_speed = damage * 8
    if kick_speed > max_kick:
        kick_speed = max_kick
    
    custom_take_hit(damage, hit_direction)


func bleed(hit_direction) -> void:
    var root = get_tree().get_root()
    for _i in range(blood_drops):
        var blood_instance = blood.instance()
        blood_instance.global_position = global_position
        
        var blood_speed = Vector2(rand_range(-1,1) * 3 * hit_direction.x, rand_range(-1,1) * 1.5 * hit_direction.y)
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
