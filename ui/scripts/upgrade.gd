extends Button # Ou TextureRect, conforme seu setup atual

# Arraste o arquivo .tres do upgrade aqui no Inspector
@export var upgrade_info: UpgradeData 

# Variável para guardar os dados atuais desta carta
var current_upgrade: UpgradeData

@onready var texture_rect = %CardTexture
@onready var name_label = $PanelContainer/VBoxContainer/Name
@onready var desc_label = $PanelContainer/VBoxContainer/Description

# Função nova e limpa
func set_upgrade_data(data: UpgradeData):
	current_upgrade = data
	
	# Atualiza o visual
	if texture_rect: texture_rect.texture = data.icon
	if name_label: name_label.text = data.title
	if desc_label: desc_label.text = data.description

func _pressed():
	# Quando clicar, manda o objeto inteiro para o Manager
	if current_upgrade:
		HudManager.pegar_upgrade(current_upgrade)
		#$Timer.start()
		#$AnimationPlayer.play("card_select")
		

func _on_timer_timeout() -> void:
	visible = false
