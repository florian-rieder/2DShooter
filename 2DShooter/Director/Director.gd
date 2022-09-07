extends Node


onready var _tree = get_tree()
var enemy_types = {
    'BaseEnemy': preload('res://Characters/BaseEnemy/BaseEnemy.tscn'),
    }
var sensed_difficulty : float
var target_difficulty : float
var max_enemies : int = 100

# call function on each member of a group:
# get_tree().call_group("my_group","my_function",args...)

var c = 0
func _process(delta):
    if c > 1:
        var n_enemies = len(get_enemies())
        estimate_difficulty()
        if n_enemies < max_enemies:
            spawn_enemies()
        c = 0
    c+=delta


func estimate_difficulty():
    var player = get_player()
    var weapon = player.weapon
#    var player_dps = weapon._seconds_per_shot * weapon.weapon.projectile.damage * len(weapon.weapon.projectile_angles)
#    print(player_dps)
    # estimate current difficulty level based on metrics
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
    for _i in range(randi() % 5):
        selected_spawnpoint.spawn_random(enemy_types['BaseEnemy'])


func get_spawnpoints():
    return _tree.get_nodes_in_group(('SpawnPoint'))


func get_enemies():
    return _tree.get_nodes_in_group('Enemy')


func get_player():
    return _tree.get_nodes_in_group('Player')[0]
