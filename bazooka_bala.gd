extends Area2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO
var damage: float = 100.0

@export var explosion_texture: Texture2D = preload("res://assets/explosao.png")
@export var explosion_radius: float = 140.0

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		explodir()
		queue_free()

func explodir() -> void:
	# 1. Instancia o sprite da explosão no local do impacto com escala 0.08
	var explosion_sprite = Sprite2D.new()
	if explosion_texture:
		explosion_sprite.texture = explosion_texture
	explosion_sprite.global_position = global_position
	explosion_sprite.scale = Vector2(0.08, 0.08)
	get_tree().current_scene.add_child(explosion_sprite)
	
	# 2. Causa dano em área (AoE) nos inimigos próximos
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy and is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance <= explosion_radius:
				if enemy.has_method("take_damage"):
					enemy.take_damage(damage)
				elif enemy.has_method("TakeDamage"):
					enemy.TakeDamage(damage)

	# 3. Configura o timer de forma independente para apagar o sprite após 0.8 segundos
	var timer = get_tree().create_timer(0.8)
	timer.timeout.connect(func():
		if is_instance_valid(explosion_sprite):
			explosion_sprite.queue_free()
	)
