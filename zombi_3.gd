extends CharacterBody2D

@export var speed: float = 120.0
@export var max_hp: float = 30.0
@export var damage_to_player: float = 10.0
var hp: float = max_hp

var can_attack: bool = true
var attack_cooldown: float = 1.0 # 1 segundo entre cada mordida

func _ready() -> void:
	hp = max_hp

func _physics_process(_delta: float) -> void:
	# Procura o player na cena dinamicamente
	var player = get_tree().current_scene.find_child("Player", true, false)
	
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		look_at(player.global_position)
		
		# Checa a distância exata até o player (sem depender de colisores chatos)
		var distance = global_position.distance_to(player.global_position)
		
		# Se encostar/chegar perto o suficiente e puder atacar
		if distance < 35.0 and can_attack:
			# Chama o método de dano no Player (suporta C# com T maiúsculo)
			if player.has_method("TakeDamage"):
				player.call("TakeDamage", damage_to_player)
			elif player.has_method("take_damage"):
				player.take_damage(damage_to_player)
				
			start_attack_cooldown()

	if hp <= 0:
		queue_free()

func take_damage(amount: float) -> void:
	hp -= amount

func start_attack_cooldown() -> void:
	can_attack = false
	
	# Segurança: se o zumbi saiu da árvore ou o jogo está recarregando, cancela
	if not is_inside_tree() or get_tree() == null:
		return
		
	await get_tree().create_timer(attack_cooldown).timeout
	
	# Nova checagem após o tempo passar (caso a cena tenha reiniciado no meio)
	if not is_inside_tree() or get_tree() == null:
		return
		
	can_attack = true
