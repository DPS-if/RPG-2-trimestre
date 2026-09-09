extends CanvasLayer

@onready var health_label: Label = $Control/MarginContainer/VBoxContainer/HealthLabel
@onready var timer_label: Label = $Control/MarginContainer/VBoxContainer/TimerLabel

func _process(delta: float) -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if not game_manager:
		return

	# Formata o tempo em Minutos:Segundos (ex: 01:25)
	var time = game_manager.elapsed_time
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	timer_label.text = "Tempo: %02d:%02d" % [minutes, seconds]

	# Mostra a vida numérica atual e máxima
	health_label.text = "Vida: %d / %d" % [int(game_manager.player_hp), int(game_manager.player_max_hp)]
