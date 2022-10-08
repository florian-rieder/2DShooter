# Weapon resource
extends Resource
class_name WeaponResource

export var name : String
export var id : String
export (Array, float) var projectile_angles = [0.0]
export var rate_of_fire : int # rpm
export var spread : float
export var kickback : int
export var shake_trauma : float
export var max_trauma : float
export (StreamTexture) var texture

# Note: It is the projectile that inflicts damage, not the weapon !
export (Resource) var projectile
export (Array, Resource) var fire_sounds
