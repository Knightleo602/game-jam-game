extends Node

# Guarda o DADO do upgrade, não só a imagem
var upgrade_selecionado: UpgradeData = null

# Sinal visual (para o mouse fantasma aparecer)
signal item_visual_mudou(textura)
# Sinal lógico (para avisar o sistema que um upgrade foi escolhido/confirmado)
signal upgrade_aplicado(upgrade: UpgradeData)
# Sinal para controlar preview
signal cursor_global_visivel(deve_mostrar: bool)
signal mascara_alterada(nova_textura: ImageTexture)

func esconder_cursor_global(esconder: bool):
	# Se esconder for TRUE, deve_mostrar é FALSE
	cursor_global_visivel.emit(!esconder)
	
func pegar_upgrade(upgrade: UpgradeData):
	upgrade_selecionado = upgrade
	# Avisa o mouse para mostrar a textura
	item_visual_mudou.emit(upgrade.icon)

func confirmar_upgrade():
	if upgrade_selecionado:
		print("CONFIRMADO: Upgrade " + upgrade_selecionado.title + " aplicado!")
		# Emite o sinal final para quem cuida dos status do player
		upgrade_aplicado.emit(upgrade_selecionado)
		
		# Limpa a seleção
		limpar_selecao()

func limpar_selecao():
	upgrade_selecionado = null
	item_visual_mudou.emit(null)

var mascara_atual_texture: ImageTexture
func salvar_mascara_customizada(nova_textura: ImageTexture):
	mascara_atual_texture = nova_textura
	#print("Mascara salva com sucesso! Tamanho: ", nova_textura.get_size())
	mascara_alterada.emit(nova_textura)
