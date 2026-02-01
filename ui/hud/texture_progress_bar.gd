extends TextureProgressBar

@export var texture_high: Texture2D  # Vida cheia/Verde
@export var texture_mid: Texture2D   # Vida média/Amarela
@export var texture_low: Texture2D   # Vida crítica/Vermelha
var healthUI: int
var maxHealthUI: int

@export var healthComponent: HealthComponent
@export var amplitude: float = 2.0
@export var speed: float = 4.0

var time: float = 0.0
var initial_x: float = 0.0

func _process(delta):
	if (texture_over == texture_low):
		time += delta
		# A mágica do Seno: cria um valor que oscila entre -1 e 1 suavemente
		var movement = sin(time * speed) * amplitude
		position.x = initial_x + movement
	else :
		position.x = initial_x

func _ready():
	initial_x = position.x
	healthUI = healthComponent.health
	maxHealthUI = healthComponent.max_health
	update_texture_style()

func _on_player_player_health_changed(new_health: int, old_health: int, max_health: int) -> void:
	healthUI = new_health
	maxHealthUI = max_health
	update_texture_style()

func update_texture_style():
	# Calcula a porcentagem (0.0 a 1.0)
	var percent = float(healthUI) / float(maxHealthUI)
	print("Percent: " + str(percent))
	
	# Lógica para trocar a textura
	# Se tiver mais de 60% de vida
	if percent > 0.6:
		if texture_over != texture_high:
			texture_over = texture_high
			
	# Se tiver entre 30% e 60%
	elif percent > 0.3:
		if texture_over != texture_mid:
			texture_over = texture_mid
			
	# Se tiver menos de 30% (Crítico)
	else:
		if texture_over != texture_low:
			texture_over = texture_low
