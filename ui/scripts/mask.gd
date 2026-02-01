extends TextureRect

@onready var preview_layer = $PreviewLayer
var mouse_inside = false

#@onready var estudio_render: SubViewport = $"../EstudioRender/SubViewport"
#
## Função ASYNC para gerar o snapshot isolado
#func gerar_snapshot_isolado() -> ImageTexture:
	#print("Iniciando renderização off-screen...")
#
	## 1. Garante que o preview visual na máscara original está escondido
	#hide_preview()
	#
	## 2. DUPLICA a máscara atual e todos os seus filhos.
	## O 'self' aqui é o nó da máscara (TextureRect ou Control)
	#var clone_da_mascara = self.duplicate()
	#
	## 3. Limpeza do Clone (Importante!)
	## O clone não pode ter o script de lógica rodando nele, senão vira bagunça.
	#clone_da_mascara.set_script(null) 
	#
	## Se o clone tiver um nó de preview, garante que ele esteja invisível/deletado
	#if clone_da_mascara.has_node("PreviewLayer"):
		#clone_da_mascara.get_node("PreviewLayer").visible = false
		## Ou melhor, delete ele do clone:
		## clone_da_mascara.get_node("PreviewLayer").queue_free()
		#
	## 4. Reseta a posição e âncoras
	## O clone precisa ficar na posição 0,0 DENTRO do SubViewport para a foto sair certa.
	#clone_da_mascara.position = Vector2.ZERO
	## Se estiver usando âncoras, pode precisar de:
	## clone_da_mascara.set_anchors_preset(Control.PRESET_TOP_LEFT)
	#
	## 5. Adiciona o clone ao estúdio
	#estudio_render.add_child(clone_da_mascara)
	#
	## 6. Espera o motor renderizar.
	## SubViewports às vezes precisam de 2 frames para atualizar completamente a primeira vez.
	#await get_tree().process_frame
	#await get_tree().process_frame
	#
	## 7. PEGA A FOTO!
	## get_texture() do SubViewport pega a imagem renderizada com fundo transparente.
	#var textura_viewport = estudio_render.get_texture()
	#
	## CRUCIAL: Temos que duplicar os dados da imagem.
	## Se não duplicarmos, a textura vai mudar no próximo frame que o viewport renderizar.
	#var imagem_final = textura_viewport.get_image().duplicate()
	#
	## 8. Limpeza
	#clone_da_mascara.queue_free() # Deleta o clone
	#
	#print("Snapshot isolado gerado com sucesso!")
	#
	## Converte de volta para Texture para usar na UI
	#return ImageTexture.create_from_image(imagem_final)

func _process(_delta):
	if HudManager.upgrade_selecionado != null and mouse_inside:
		show_preview()
	else:
		hide_preview()

func _on_mouse_entered():
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
	mouse_inside = false
	hide_preview()

func show_preview():
	# Só atualiza se for necessário (performance)
	if !preview_layer.visible:
		preview_layer.visible = true
		preview_layer.texture = HudManager.upgrade_selecionado.icon
		# Opcional: Ajustar tamanho se necessário
		preview_layer.size = Vector2(40, 40) 
	
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
	nova_camada.size = Vector2(200, 200) # Tamanho do ícone na máscara
	
	# Centraliza no mouse local
	nova_camada.position = get_local_mouse_position() - (nova_camada.size / 2)
	add_child(nova_camada)
	
	# Chama a nova função
	#var icone_consolidado = await gerar_snapshot_isolado()
	# Manda para o gerenciador
	HudManager.salvar_mascara_customizada(null)

func gerar_snapshot_da_mascara() -> ImageTexture:
	# 1. Garante que o preview sumiu para não sair na foto
	hide_preview()
	
	# 2. Espera o motor desenhar o frame atual (Indispensável)
	await get_tree().process_frame
	
	# 3. Pega a imagem da tela inteira (Viewport)
	var viewport_texture = get_viewport().get_texture()
	var imagem_tela = viewport_texture.get_image()
	
	# 4. Define a região exata onde a máscara está
	# get_global_rect() pega a posição e tamanho da máscara na tela
	var area_de_corte = get_global_rect()
	
	# 5. Corta a imagem (get_region retorna uma nova imagem cortada)
	var imagem_cortada = imagem_tela.get_region(area_de_corte)
	
	# 6. Converte de volta para Texture para ser usada em Sprites/UI
	var textura_final = ImageTexture.create_from_image(imagem_cortada)
	
	return textura_final
