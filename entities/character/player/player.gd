class_name Player extends CharacterBody2D

signal player_died
signal player_health_changed(new_health: int, old_health: int, max_health: int)

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var gun: Gun = $AnimatedSprite2D/Gun
@onready var sword: Sword = $AnimatedSprite2D/Sword
@onready var death_audio_player: AudioStreamPlayer2D = $DeathAudioPlayer

# Sinais de Experiência (Novos)
# Envia: XP atual, XP necessário para o próx nível e a % (0.0 a 1.0)
signal xp_changed(current_xp: int, max_xp: int, progress_percentage: float)
signal leveled_up(new_level: int)

# Configurações de Level
@export var current_level: int = 1
@export var level_up_xp: int = 100
@export var level_up_xp_increase_rate: float = 1.2 # Mudei para float para aceitar decimais
@export var current_xp: int = 0

func _get_input() -> Vector2:
	if health_component.is_dead():
		return Vector2.ZERO
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func _physics_process(delta: float) -> void:
	var input = _get_input()
	movement_component.move(self , input, delta)


func _ready() -> void:
	GameManager.experience_gained.connect(_on_xp_gained)
	HudManager.upgrade_aplicado.connect(_on_upgraded)
	update_xp_ui()


func _process(_delta: float) -> void:
	if health_component.is_dead():
		return
	movement_component.animate_movement()


func _on_death() -> void:
	player_died.emit()
	gun.disable()
	sword.disable()
	movement_component.animated_sprite.stop()
	print("Player has died.")
	death_audio_player.play()
	$AnimatedSprite2D.play("death")
	GameManager.notify_player_died(level_up_xp)

func _on_health_changed(new_health: int, old_health: int) -> void:
	player_health_changed.emit(new_health, old_health, health_component.max_health)

func _on_xp_gained(amount: int):
	current_xp += amount
	print("Player recebeu ", amount, " de XP! Total: ", current_xp)
	check_level_up()
	update_xp_ui() # Atualiza a barra sempre que ganhar XP

func check_level_up():
	# Usamos 'while' caso o XP ganho seja suficiente para subir 2 ou 3 niveis de uma vez
	var subiu_de_nivel = false
	
	while current_xp >= level_up_xp:
		current_xp -= level_up_xp
		current_level += 1
		
		# Aumenta a dificuldade do próximo nível
		level_up_xp = int(level_up_xp * level_up_xp_increase_rate)
		subiu_de_nivel = true
		
		print("LEVEL UP! Nível atual: ", current_level, " | Próximo XP alvo: ", level_up_xp)
		leveled_up.emit(current_level)

	# Se subiu de nível, podemos abrir o menu de cartas aqui ou via sinal
	if subiu_de_nivel:
		# Exemplo: Chamar o menu de cartas
		GameManager.notify_player_leveled_up(current_level)
		pass

func update_xp_ui():
	# Calcula a porcentagem (0.0 a 1.0)
	# Evita divisão por zero
	var percentage: float = 0.0
	if level_up_xp > 0:
		percentage = float(current_xp) / float(level_up_xp)
	
	# Emite o sinal para a HUD
	xp_changed.emit(current_xp, level_up_xp, percentage)

func _on_upgraded(upgrade: UpgradeData):
	var intAmount = int(upgrade.value_modifier)
	
	match upgrade.attribute_name:
		"maxHealth":
			health_component.increase_max_health(intAmount)
		"health":
			health_component.heal(intAmount)
		"atkPower":
			var amount: int = intAmount * 0.6
			gun.extra_bullet_damage += amount
			sword.extra_sword_damage += amount
		"atkSpeed":
			sword.decrease_atk_timer(upgrade.value_modifier)
		"moveSpeed":
			velocity_component.increase_speed(intAmount)
		"gunCapacity":
			gun.increase_ammo_capacity(intAmount)
		"gunAtkSpeed":
			gun.decrease_shoot_timer(upgrade.value_modifier)
		"gunReload":
			gun.decrease_reload_timer(upgrade.value_modifier)
