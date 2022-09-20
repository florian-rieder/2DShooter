extends Resource
class_name ProjectileResource


export var speed : int = 500
export var damage : int = 0
export var piercing : int = 0 # how many objects the projectile can go through
export var pierce_speed_loss : int = 0

export (SpriteFrames) var frames

export (PackedScene) var impact
export (Array, Resource) var impact_sounds
export var impact_quantity : int = 1
export var impact_deviation : int = 0
