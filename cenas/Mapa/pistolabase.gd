extends Sprite2D

@export var attack_range: float = 250.0
@export var bullet_scene: PackedScene = preload("res://bala.tscn")
@export var bazooka_bullet_scene: PackedScene

var fire_cooldown: float = 0.85
var damage: float = 15.0
var can_fire: bool = true

var current_weapon: int = 0 # 0 = Pistola, 1 = Uzi, 2 = Bazooka

@export var uzi_texture: Texture2D = preload("res://assets/player/uzi.png")
@export var uzi_scale: Vector2 = Vector2(0.018, 0.018) 

@export var bazooka_texture: Texture2D = preload("res://assets/player/bazooka.png")
@export var bazooka_scale: Vector2 = Vector2(0.027, 0.027)

var original_texture: Texture2D
var original_scale: Vector2

func _ready() -> void:
	original_texture = texture
	original_scale = scale

func _process(_delta: float) -> void:
	check_weapon_upgrade()
	
	var target = find_closest_enemy()
	if target:
		look_at(target.global_position)
		if can_fire:
			shoot(target)

func check_weapon_upgrade() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if not game_manager:
		return
		
	var time = game_manager.elapsed_time
	
	# Mudado para 80 segundos
	if time >= 80.0 and current_weapon < 2:
		upgrade_to_bazooka()
	elif time >= 40.0 and time < 80.0 and current_weapon < 1:
		upgrade_to_uzi()

func upgrade_to_uzi() -> void:
	current_weapon = 1
	fire_cooldown = 0.20
	damage = 6.5
	
	if uzi_texture:
		texture = uzi_texture
		scale = uzi_scale

func upgrade_to_bazooka() -> void:
	current_weapon = 2
	fire_cooldown = 1.0
	damage = 100.0
	
	if bazooka_texture:
		texture = bazooka_texture
		scale = bazooka_scale

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
	
	var active_scene = bullet_scene
	if current_weapon == 2 and bazooka_bullet_scene:
		active_scene = bazooka_bullet_scene
	
	if active_scene:
		var projectile_instance = active_scene.instantiate()
		projectile_instance.global_position = global_position
		
		var direcao = (target.global_position - global_position).normalized()
		projectile_instance.direction = direcao
		
		if "damage" in projectile_instance:
			projectile_instance.damage = damage
			
		get_tree().current_scene.add_child(projectile_instance)
	
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
