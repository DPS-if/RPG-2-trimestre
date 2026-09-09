extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
var damage: float = 15.0

var max_pierce: int = 5      
var enemies_hit: int = 0    
var hit_enemies: Array = [] 

# Variáveis da Bazooka
var is_bazooka: bool = false
@export var explosion_texture: Texture2D = preload("res://assets/explosao.png")
@export var explosion_radius: float = 140.0 # Raio da área de dano da explosão

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if is_bazooka:
			explodir()
			queue_free()
			return

		# Lógica padrão de perfuração (Pistola / Uzi)
		if body in hit_enemies:
			return
			
		hit_enemies.append(body)
		enemies_hit += 1
		
		if body.has_method("take_damage"):
			body.take_damage(damage)
		elif body.has_method("TakeDamage"):
			body.TakeDamage(damage)
			
		if enemies_hit >= max_pierce:
			queue_free()

func explodir() -> void:
	# 1. Instancia o sprite da explosão no local do impacto
	var explosion_sprite = Sprite2D.new()
	if explosion_texture:
		explosion_sprite.texture = explosion_texture
	explosion_sprite.global_position = global_position
	explosion_sprite.scale = Vector2(0.4, 0.4) # Ajuste o tamanho da explosão se necessário
	get_tree().current_scene.add_child(explosion_sprite)
	
	# 2. Causa dano em área (AoE) em todos os inimigos dentro do raio da explosão
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy and is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance <= explosion_radius:
				if enemy.has_method("take_damage"):
					enemy.take_damage(damage)
				elif enemy.has_method("TakeDamage"):
					enemy.TakeDamage(damage)

	# 3. Remove o sprite da explosão após 0.25 segundos
	var timer = get_tree().create_timer(0.25)
	await timer.timeout
	if is_instance_valid(explosion_sprite):
		explosion_sprite.queue_free()
