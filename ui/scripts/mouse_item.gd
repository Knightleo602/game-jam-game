extends TextureRect
#
#func _ready():
	## Começa invisível
	#visible = false
	#z_index = 10
	## Conecta com o sinal do Gerenciador
	#HudManager.item_visual_mudou.connect(_on_item_mudou)
	#HudManager.cursor_global_visivel.connect(_mask_preview)
	#HudManager.upgrade_aplicado.connect(_on_confirm_upgrade)
#
#func _process(delta):
	#if visible:
		## Faz a imagem seguir o mouse
		## O "- size / 2" é para centralizar a imagem no cursor
		#global_position = get_global_mouse_position() - (size / 2)
#
#func _on_item_mudou(nova_textura):
	#if nova_textura:
		#texture = nova_textura
		#visible = true
		## Opcional: ajustar tamanho
		#size = Vector2(150, 150) 
	#else:
		#visible = false
	#visible = false
		#
#func _mask_preview(deve_mostrar: bool):
	#visible = deve_mostrar
	#visible = false
	#
#func _on_confirm_upgrade(upgrade: UpgradeData):
	#visible = false
	
