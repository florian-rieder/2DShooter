extends Node2D

class_name Arena

const Util = preload("res://Utility.gd")

# enemies
export (Dictionary) var enemy_types = Dictionary()
export var max_enemies = 75
export var kill_goal = 200
var kill_count = 0
var enemies = Array()
var spawnpoints = null

onready var player = get_player()

# spawn waves
onready var wave_timer = $WaveTimer
export var wave_timeout = 1
var wave_size = 15

# Director bit
var sensed_difficulty = 0
export var target_difficulty = 1


func _ready():
    spawnpoints = get_spawnpoints()
    wave_timer.start(wave_timeout)


func sense_difficulty():
    var enemy_cap_percentage = len(enemies) / max_enemies

    # find the player DPS divided by the health pool of all enemies
    var weapon = player.weapon
    var projectile_damage = 20 # FIXME: find out how to get the projectile damage...
    var rounds_per_second = weapon.weapon.rate_of_fire / 60 # rpm -> rps
    var enemy_health_pool = 0
    for enemy in enemies:
        enemy_health_pool += enemy.health
    var dps_over_enemy_health_pool = rounds_per_second * projectile_damage / enemy_health_pool
    # estimate current difficulty level based on metrics
    return enemy_cap_percentage + dps_over_enemy_health_pool


func adjust_difficulty():
    if sense_difficulty() > target_difficulty:
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


func spawn_wave():
    var selected_spawnpoint = get_random_offscreen_spawnpoint()
    # TODO: choose enemy types and numbers
    for _i in range(randi() % wave_size):
        var chosen_enemy_type = Util.weighted_random_choice(enemy_types)
        var new_enemy = selected_spawnpoint.spawn_random(chosen_enemy_type)
        new_enemy.arena = self
        enemies.append(new_enemy)


func enemy_died(enemy):
    kill_count += 1
    var i = 0
    for e in enemies:
        if e == enemy:
            enemies.remove(i)
            return
        i += 1


func _on_WaveTimer_timeout():
    #print(len(enemies))
    print(kill_count)
    if len(enemies) >= max_enemies:
        return
    spawn_wave()
    wave_timer.start(wave_timeout)


func get_player():
    return get_tree().get_nodes_in_group('Player')[0]


func get_enemies():
    return get_tree().get_nodes_in_group('Enemy')


func get_spawnpoints():
    return get_tree().get_nodes_in_group(('SpawnPoint'))


func get_random_offscreen_spawnpoint():
    # get level defined spawnpoints
    var available_spawnpoints = get_spawnpoints()
    var possible_spawnpoints = []

    # get possible spawnpoints
    for spawnpoint in available_spawnpoints:
        # check that the spawnpoint is off screen
        if not spawnpoint.is_on_screen() and spawnpoint.active:
            possible_spawnpoints.append(spawnpoint)

    # TODO: select spawnpoint
    if len(possible_spawnpoints) <= 0:
        print('No spawnpoint available')
        return

    return possible_spawnpoints[randi() % len(possible_spawnpoints)]

