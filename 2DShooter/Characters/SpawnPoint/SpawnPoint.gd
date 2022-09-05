extends VisibilityNotifier2D
class_name SpawnPoint

# the component is stored as a NodePath in the editor.
# onready, we can cache the component by getting the node at the NodePath
export(NodePath) onready var entity_layer = get_node(entity_layer)


func spawn_random(entity):
    # get random position within bounds
    var x = round(rand_range(rect.position.x, rect.position.x+rect.end.x))
    var y = round(rand_range(rect.position.y, rect.position.y+rect.end.y))
    # spawn the given entity
    var instance = entity.instance()
    instance.global_position = global_position + Vector2(x,y)
    entity_layer.add_child(instance)
