extends CanvasLayer

@onready var time_label: Label = $Panel/VBoxContainer/TimeLabel
@onready var restart_button: Button = %Button

func _ready() -> void:
	get_tree().paused = true
	
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var elapsed = game_manager.elapsed_time
		var minutes = int(elapsed) / 60
		var seconds = int(elapsed) % 60
		
		if minutes > 0:
			time_label.text = "Você durou %d minuto(s) e %d segundo(s) vivo!" % [minutes, seconds]
		else:
			time_label.text = "Você durou %d segundos vivo!" % int(elapsed)
	else:
		time_label.text = "Você durou algum tempo vivo!"

	if restart_button:
		if not restart_button.pressed.is_connected(_on_restart_pressed):
			restart_button.pressed.connect(_on_restart_pressed)
	else:
		print("ERRO CRÍTICO: Botão não encontrado!")

func _on_restart_pressed() -> void:
	print(">>> O botão de reiniciar FOI CLICADO com sucesso!")
	
	# 1. Reseta o tempo e os dados do GameManager antes de sair
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.reset_game()
	
	# 2. Despausa o jogo obrigigatoriamente antes de mudar de cena
	get_tree().paused = false
	
	# 3. Muda para a tela inicial
	var caminho_da_cena = "res://cenas/TelaInicial/telaInicial.tscn" 
	var erro = get_tree().change_scene_to_file(caminho_da_cena)
	if erro != OK:
		print(">>> ERRO: Não foi possível carregar a cena! Código do erro: ", erro)
