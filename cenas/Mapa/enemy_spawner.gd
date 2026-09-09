extends Node2D

@export var zombie_scenes: Array[PackedScene] = [
	preload("res://zombi.tscn"),
	preload("res://zombi2.tscn"),
	preload("res://zombi3.tscn"),
	preload("res://zombi4.tscn")
]

var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if not game_manager:
		return

	spawn_timer += delta

	# Começa em 2.0s e acelera até o limite caótico de 0.01 segundos
	var elapsed = game_manager.elapsed_time
	var current_spawn_interval = max(0.01, 2.0 - (elapsed * 0.015))

	if spawn_timer >= current_spawn_interval:
		spawn_timer = 0.0
		spawn_zombie(elapsed)

func spawn_zombie(time: float):
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	if spawn_points.is_empty():
		return
		
	var random_point = spawn_points[randi() % spawn_points.size()]
	
	var unlocked_zombies_count = 1
	if time >= 60.0:
		unlocked_zombies_count = 4
	elif time >= 40.0:
		unlocked_zombies_count = 3
	elif time >= 20.0:
		unlocked_zombies_count = 2
	else:
		unlocked_zombies_count = 1
		
	var selected_index = randi() % unlocked_zombies_count
	var selected_scene = zombie_scenes[selected_index]
	var zombie = selected_scene.instantiate()
	zombie.global_position = random_point.global_position
	get_tree().current_scene.add_child(zombie)
