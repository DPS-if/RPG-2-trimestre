extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO
var damage: float = 15.0

var max_pierce: int = 5     # Quantos zumbis ela pode atravessar no máximo
var enemies_hit: int = 0    # Contador de zumbis já atingidos
var hit_enemies: Array = [] # Lista para não bater duas vezes no mesmo zumbi

func _ready() -> void:
	if not is_connected("body_entered", _on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		# Se a bala já bateu neste zumbi específico, ignora
		if body in hit_enemies:
			return
			
		# Registra que atingiu este zumbi
		hit_enemies.append(body)
		enemies_hit += 1
		
		# Causa dano no zumbi (compatível com C# ou GDScript)
		if body.has_method("take_damage"):
			body.take_damage(damage)
		elif body.has_method("TakeDamage"):
			body.TakeDamage(damage)
			
		# Se atingiu o limite máximo de 5 perfurações, destrói a bala
		if enemies_hit >= max_pierce:
			queue_free()
