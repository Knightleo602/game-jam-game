extends CanvasLayer

@export_group("Referências")
@export var player: Player
@export var healthComponent: HealthComponent

@export_group("Configuração Vida")
@export var health_textures: Array[Texture2D] # Texturas das rachaduras
@export var amplitude: float = 4.0
@export var speed: float = 70.0

# Variáveis internas
var healthUI: int
var maxHealthUI: int
var indexUI: int
var time: float = 0.0
var initial_x: float = 0.0

@onready var mask_bar = $MaskBar # Seu TextureProgressBar principal
@onready var level_up_screen = $LevelUp

func _ready():
	visible = true
	
	# Configurações iniciais da Barra
	initial_x = mask_bar.position.x
	mask_bar.min_value = 0
	mask_bar.max_value = 100
	mask_bar.value = 0 # Começa com 0 de XP
	
	# Configuração das Texturas de Vida (Rachaduras)
	indexUI = health_textures.size()
	if health_textures.size() == 0:
		push_error("ERRO: Array 'health_textures' vazio!")
		return
		
	if healthComponent:
		healthUI = healthComponent.health
		maxHealthUI = healthComponent.max_health
		update_texture_style() # Aplica a rachadura inicial (nenhuma)

	# Conexões com o Player
	if player:
		player.xp_changed.connect(_on_player_xp_changed)
		player.leveled_up.connect(_on_player_leveled_up)
		player.player_health_changed.connect(_on_player_health_changed)
	
	# Conexão da Customização (Snapshot da máscara)
	HudManager.mascara_alterada.connect(_on_level_up_finish)
	GameManager.player_died.connect(_on_game_over)

func _process(delta):
	# EFEITO DE TREMOR (SHAKE)
	# Se a vida estiver baixa (índice das texturas baixo = muito quebrado)
	if (indexUI <= 3):
		time += delta
		var movement = sin(time * speed) * amplitude
		mask_bar.position.x = initial_x + movement
	else:
		mask_bar.position.x = initial_x
		time = 0.0

# --- LÓGICA DE XP (O Enchimento da Barra) ---
func _on_player_xp_changed(_current_xp, _max_xp, percentage: float):
	# Atualiza o progresso da barra (enchimento verde/azul)
	# O tween deixa a subida da barra suave
	var tween = create_tween()
	tween.tween_property(mask_bar, "value", percentage * 100, 0.5).set_trans(Tween.TRANS_SINE)

func _on_player_leveled_up(new_level: int):
	print("HUD: Level Up detectado! Nível: ", new_level)
	abrir_tela_levelup()

# --- LÓGICA DE VIDA (A Textura de Cima / Rachaduras) ---
func _on_player_health_changed(new_health: int, _old_health: int, max_health: int) -> void:
	healthUI = new_health
	maxHealthUI = max_health
	update_texture_style()

func update_texture_style():
	if health_textures.size() == 0: return
	
	var percent = float(healthUI) / float(maxHealthUI)
	percent = clamp(percent, 0.0, 1.0)
	
	var max_index = health_textures.size() - 1
	var index = int(percent * max_index)
	indexUI = index
	
	# Troca a textura que fica POR CIMA da barra (Rachaduras)
	var target_texture = health_textures[index]
	if mask_bar.texture_over != target_texture:
		mask_bar.texture_over = target_texture

# --- LÓGICA DA CUSTOMIZAÇÃO (O Fundo / Rosto) ---
func abrir_tela_levelup():
	get_tree().paused = true
	
	mask_bar.hide()
	level_up_screen.show()
	level_up_screen._leveled_up()

func _on_level_up_finish(nova_textura: ImageTexture):
	if nova_textura != null:
		# Define a máscara customizada (foto) como o FUNDO da barra
		mask_bar.texture_under = nova_textura
		
	level_up_screen.hide()
	mask_bar.show()
	get_tree().paused = false
	
func _on_game_over(score: int):
	visible = false
