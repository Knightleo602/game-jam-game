extends Control

# Arraste todos os seus arquivos .tres de upgrades para esta lista no Inspector
@export var available_upgrades: Array[UpgradeData] = []

@onready var card1 = $Upgrade1 # Supondo que sejam nós filhos diretos
@onready var card2 = $Upgrade2

func _ready():
	visible = false

func _leveled_up():
	visible = true
	card1.visible = true
	card2.visible = true
	generate_random_choices()

func generate_random_choices():
	# 1. Verifica se temos upgrades suficientes
	if available_upgrades.size() == 0:
		print("Erro: Nenhum upgrade cadastrado no Inspector!")
		return

	# 2. Cria uma cópia da lista para podermos embaralhar sem estragar a original
	var deck = available_upgrades.duplicate()
	
	# 3. Embaralha a lista
	deck.shuffle()
	
	# 4. Pega os primeiros itens da lista embaralhada
	var pick1 = deck[0]
	var pick2 = deck[1]
	
	# 5. Manda para as cartas
	card1.set_upgrade_data(pick1)
	card2.set_upgrade_data(pick2)
