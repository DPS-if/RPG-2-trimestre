extends Node

var elapsed_time: float = 0.0
var player_hp: float = 100.0
var player_max_hp: float = 100.0

func _process(delta: float) -> void:
	elapsed_time += delta

# Função chamada pelo Player para atualizar a vida na UI
func update_hp(curr: float, max_hp: float) -> void:
	player_hp = curr
	player_max_hp = max_hp
