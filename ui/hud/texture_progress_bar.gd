extends TextureProgressBar

@export var texture_high: Texture2D  # Vida cheia/Verde
@export var texture_mid: Texture2D   # Vida média/Amarela
@export var texture_low: Texture2D   # Vida crítica/Vermelha
var healthUI: int
var maxHealthUI: int

func _ready():
	healthUI = $"../../HealthComponent".health
	maxHealthUI = $"../../HealthComponent".max_health
	update_texture_style()

func _on_player_player_health_changed(health: int, maxHealth: int) -> void:
	healthUI = health
	maxHealthUI = maxHealth
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
