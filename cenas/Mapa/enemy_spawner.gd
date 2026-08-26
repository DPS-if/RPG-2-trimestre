extends Node2D

# Lista com os diferentes tipos de zumbis (adicione todos eles aqui)
@export var enemy_scenes: Array[PackedScene] = [
	preload("res://zombi.tscn"),
	preload("res://zombi2.tscn"), # Substitua pelos caminhos reais das suas cenas de zumbi
	preload("res://zombi3.tscn"),
	preload("res://zombi4.tscn")
]

@export var spawn_interval: float = 1.0

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_spawn_timeout)
	add_child(timer)

func _on_spawn_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if enemy_scenes.is_empty():
		return
		
	# Pega os pontos de marcação do mapa
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	if spawn_points.is_empty():
		print("Aviso: Nenhum Marker2D encontrado no grupo 'spawn_points'!")
		return
		
	# 1. Escolhe um marcador aleatório
	var random_point = spawn_points.pick_random() as Node2D
	
	# 2. Escolhe aleatoriamente uma das cenas de zumbi da nossa lista
	var chosen_enemy_scene = enemy_scenes.pick_random()
	
	if chosen_enemy_scene:
		# Instancia o zumbi sorteado
		var enemy = chosen_enemy_scene.instantiate()
		enemy.global_position = random_point.global_position
		
		# Adiciona na cena principal
		get_tree().current_scene.add_child(enemy)
