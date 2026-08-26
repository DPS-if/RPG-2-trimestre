extends Sprite2D

@export var attack_range: float = 300.0
@export var bullet_scene: PackedScene = preload("res://bala.tscn") # Carrega a cena da bala automaticamente
var fire_cooldown: float = 0.85
var can_fire: bool = true

func _process(_delta: float) -> void:
	var target = find_closest_enemy()
	
	if target:
		look_at(target.global_position)
		
		if can_fire:
			shoot(target)

func find_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy: Node2D = null
	var min_distance = attack_range
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_enemy = enemy
			
	return closest_enemy

func shoot(target: Node2D) -> void:
	can_fire = false
	
	if bullet_scene:
		var bala_instance = bullet_scene.instantiate()
		
		# Define a posição inicial da bala na ponta da pistola
		bala_instance.global_position = global_position
		
		# Calcula a direção para o zumbi e passa para a bala
		var direcao = (target.global_position - global_position).normalized()
		bala_instance.direction = direcao
		
		# Adiciona a bala na cena principal para ela voar livremente
		get_tree().current_scene.add_child(bala_instance)
	
	# Cooldown do tiro
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
