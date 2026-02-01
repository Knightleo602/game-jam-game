extends Control

@onready var preview_layer = $PreviewLayer
var mouse_inside = false

func _process(delta):
	if HudManager.upgrade_selecionado != null and mouse_inside:
		show_preview()
	else:
		hide_preview()

func _on_mouse_entered():
	print("_on_mouse_entered")
	mouse_inside = true
	check_preview() # Chama uma função pra verificar

# --- A FUNÇÃO QUE VOCÊ PEDIU ---
func check_preview():
	# A Lógica: Só mostramos se o mouse estiver dentro E tivermos um item na mão
	if mouse_inside and HudManager.upgrade_selecionado != null:
		show_preview()
	else:
		hide_preview()
		
func _on_mouse_exited():
	print("_on_mouse_exited")
	mouse_inside = false
	hide_preview()

func show_preview():
	# Só atualiza se for necessário (performance)
	if !preview_layer.visible:
		preview_layer.visible = true
		preview_layer.texture = HudManager.upgrade_selecionado.icon
		# Opcional: Ajustar tamanho se necessário
		preview_layer.size = Vector2(50, 50) 
	
	# Move o preview para seguir o mouse (Localmente dentro da máscara)
	# Centraliza subtraindo metade do tamanho
	preview_layer.position = get_local_mouse_position() - (preview_layer.size / 2)
	
	# Avisa o HudManager para esconder o cursor global
	HudManager.esconder_cursor_global(true)

func hide_preview():
	if preview_layer.visible:
		preview_layer.visible = false
		
	HudManager.esconder_cursor_global(false)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Verifica se tem algo na "mão" do gerenciador
		if HudManager.upgrade_selecionado != null:
			# 1. Pega a textura para "carimbar" na máscara (Visual)
			anexar_visual(HudManager.upgrade_selecionado.icon)
			# 2. Confirma a lógica (Aumentar status, emitir sinal final)
			HudManager.confirmar_upgrade()

func anexar_visual(textura):
	var nova_camada = TextureRect.new()
	nova_camada.texture = textura
	nova_camada.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	nova_camada.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nova_camada.size = Vector2(50, 50) # Tamanho do ícone na máscara
	
	# Centraliza no mouse local
	nova_camada.position = get_local_mouse_position() - (nova_camada.size / 2)
	add_child(nova_camada)
