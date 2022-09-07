extends Resource
class_name ProjectileResource


export var speed : int
export var damage : int

export (SpriteFrames) var frames

export (PackedScene) var impact
export (Array, Resource) var impact_sounds
export var impact_quantity : int = 1
export var impact_deviation : int = 0