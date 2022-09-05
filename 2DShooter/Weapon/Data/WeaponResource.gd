# Weapon resource
extends Resource
class_name WeaponResource


export (Array, float) var projectile_angles = [0.0]
export var rate_of_fire : int # rpm
export var inaccuracy : float
export var kickback : int
export var shake_trauma : float

# Note: It is the projectile that inflicts damage, not the weapon !
export (PackedScene) var projectile
export (Array, Resource) var fire_sounds
