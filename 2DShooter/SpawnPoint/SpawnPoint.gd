extends VisibilityNotifier2D
class_name SpawnPoint

# the component is stored as a NodePath in the editor.
# onready, we can cache the component by getting the node at the NodePath
export(NodePath) onready var entity_layer = get_node(entity_layer)
export var active = true


func _ready():
    add_to_group("SpawnPoint")


func spawn_random(entity : PackedScene):
    # get random position within bounds
    var x = round(rand_range(rect.position.x, rect.end.x))
    var y = round(rand_range(rect.position.y, rect.end.y))
    # spawn the given entity
    var instance = entity.instance()
    instance.position = position + Vector2(x,y)
    entity_layer.add_child(instance)
    return instance
