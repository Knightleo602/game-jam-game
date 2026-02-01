extends Node

# --- SINAIS DE JOGO ---
# Emite quando qualquer fonte de XP (inimigo, item) fornece experiência
signal experience_gained(amount: int)
signal player_leveled_up(level: int)

signal player_died(score: int)

# (Opcional) Sinal específico se você quiser contar abates para missões
signal enemy_defeated(enemy_name: String)
signal enemy_defeated_obj(enemy: Enemy)

# --- FUNÇÃO CHAMADA PELO INIMIGO ---
func notify_enemy_death(enemy: Enemy):
	print("GameManager: Inimigo ", enemy.name, " morreu. XP: ", enemy.exp_on_death)
	
	# Avisa quem estiver ouvindo (Player, UI de XP, Sistema de Level)
	experience_gained.emit(enemy.exp_on_death)
	enemy_defeated.emit(enemy.name)
	enemy_defeated_obj.emit(enemy)

func notify_player_leveled_up(level: int):
	print("GameManager: Player subiu de nivel: ", level)
	player_leveled_up.emit(level)
	
func notify_player_died(score: int):
	player_died.emit(score)
