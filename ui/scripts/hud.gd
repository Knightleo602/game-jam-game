extends CanvasLayer

@export var health_textures: Array[Texture2D] 
@export var healthComponent: HealthComponent
@export var amplitude: float = 4.0
@export var speed: float = 70.0

var healthUI: int
var maxHealthUI: int
var indexUI: int

var time: float = 0.0
var initial_x: float = 0.0

func _ready():
	indexUI = health_textures.size()
	initial_x = $MaskBar.position.x
	# Verificação de segurança para garantir que as texturas foram carregadas
	if health_textures.size() == 0:
		push_error("ERRO: O Array 'health_textures' está vazio! Adicione as texturas no Inspector.")
		return
		
	healthUI = healthComponent.health
	maxHealthUI = healthComponent.max_health
	update_texture_style()
	
	HudManager.mascara_alterada.connect(_on_level_up_finish)
	
func _process(delta):
	# Verificação de segurança
	if health_textures.size() == 0: return

	# ALTERAÇÃO 2: A lógica de tremer agora verifica se a textura atual é a de índice 0 (Crítica)
	if (indexUI <= 3):
		time += delta
		var movement = sin(time * speed) * amplitude
		$MaskBar.position.x = initial_x + movement
	else:
		$MaskBar.position.x = initial_x
		# Reseta o tempo para que o seno não continue "correndo" invisível
		time = 0.0

func _on_player_player_health_changed(new_health: int, old_health: int, max_health: int) -> void:
	healthUI = new_health
	maxHealthUI = max_health
	update_texture_style()
	_on_level_up()

func update_texture_style():
	if health_textures.size() == 0: return
	
	# Calcula a porcentagem (0.0 a 1.0) e garante que não ultrapasse os limites
	var percent = float(healthUI) / float(maxHealthUI)
	percent = clamp(percent, 0.0, 1.0)
	
	print("Percent: " + str(percent))
	
	# ALTERAÇÃO 3: Lógica matemática para selecionar a textura
	# Mapeia a porcentagem (0 a 1) para o índice do array (0 a 9)
	var max_index = health_textures.size() - 1
	var index = int(percent * max_index)
	indexUI = index
	
	# Garante que peguemos a textura correta do array
	var target_texture = health_textures[index]
	
	# Aplica a textura se for diferente da atual
	if $MaskBar.texture_over != target_texture:
		$MaskBar.texture_over = target_texture

func _on_level_up():
	$MaskBar.hide()
	$LevelUp._leveled_up()
	
func _on_level_up_finish(nova_textura: ImageTexture):
	print("_on_level_up_finish")
	if(nova_textura != null):
		print("nova_textura != null")
		$MaskBar.texture_under = nova_textura
	$LevelUp.hide()
	$MaskBar.show()
	
