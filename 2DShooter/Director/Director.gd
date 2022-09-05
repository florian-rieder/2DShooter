extends Node

onready var _tree = get_tree()

var enemy_types = {
    'BaseEnemy': preload('res://Characters/BaseEnemy/BaseEnemy.tscn'),
    }

var sensed_difficulty : float
var target_difficulty : float

# call function on each member of a group:
# get_tree().call_group("my_group","my_function",args...)

var c = 0
func _process(delta):
    if c > 1:
        spawn_enemies()
        c = 0
    c+=delta

func estimate_difficulty():
    # estimate current difficulty level based on metrics
    var n_enemies = len(get_enemies())
    
    pass


func adjust_difficulty():
    if sensed_difficulty > target_difficulty:
        # make it easier:
        # - despawn a few off screen enemies
        # - reduce special count
        # - reduce HP of enemies on screen
        pass
    else:
        # make it harder:
        # - spawn more enemies
        # - spawn more special enemies
        pass


func spawn_enemies():
    # get level defined spawnpoints
    var spawnpoints = get_spawnpoints()
    var possible_spawnpoints = []

    # get possible spawnpoints
    for spawnpoint in spawnpoints:
        # check that the spawnpoint is off screen
        if not spawnpoint.is_on_screen():
            possible_spawnpoints.append(spawnpoint)

    # TODO: select spawnpoint
    if len(possible_spawnpoints) <= 0:
        return

    var selected_spawnpoint = possible_spawnpoints[0]

    # TODO: choose enemy types and numbers
    for _i in range(randi() % 2):
        selected_spawnpoint.spawn_random(enemy_types['BaseEnemy'])


func get_spawnpoints():
    return _tree.get_nodes_in_group(('SpawnPoint'))


func get_enemies():
    return _tree.get_nodes_in_group('Enemy')


func get_player():
    return _tree.get_nodes_in_group('Player')
