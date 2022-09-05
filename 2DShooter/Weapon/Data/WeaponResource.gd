# Weapon resource
extends Resource
class_name WeaponResource


export var rate_of_fire : int
export var inaccuracy : float
export var kickback : int
export var shake_trauma : float

export (PackedScene) var projectile
export (Array, Resource) var fire_sounds

func is_type(type): return type == "WeaponResource" or .is_type(type)
func    get_type(): return "WeaponResource"
