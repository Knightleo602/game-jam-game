extends Node

# --- SINAIS DE JOGO ---
# Emite quando qualquer fonte de XP (inimigo, item) fornece experiência
signal experience_gained(amount: int)
signal player_leveled_up(level: int)

signal player_died(score: int)

# (Opcional) Sinal específico se você quiser contar abates para missões
signal enemy_defeated(enemy_name: String)

# --- FUNÇÃO CHAMADA PELO INIMIGO ---
func notify_enemy_death(xp_reward: int, enemy_name: String = "Inimigo"):
	print("GameManager: Inimigo ", enemy_name, " morreu. XP: ", xp_reward)
	
	# Avisa quem estiver ouvindo (Player, UI de XP, Sistema de Level)
	experience_gained.emit(xp_reward)
	enemy_defeated.emit(enemy_name)

func notify_player_leveled_up(level: int):
	print("GameManager: Player subiu de nivel: ", level)
	player_leveled_up.emit(level)
	
func notify_player_died(score: int):
	player_died.emit(score)
