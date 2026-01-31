extends TextureRect

# Altura do flutuar (quantos pixels ele sobe/desce)
@export var amplitude: float = 10.0
# Velocidade do movimento
@export var speed: float = 2.0

# Variável para contar o tempo
var time: float = 0.0
# Para lembrar onde o objeto estava originalmente
var initial_y: float = 0.0

func _ready():
	# Salva a posição Y inicial para usar como base
	initial_y = position.y

func _process(delta):
	time += delta
	# A mágica do Seno: cria um valor que oscila entre -1 e 1 suavemente
	var movement = sin(time * speed) * amplitude
	
	# Aplica o movimento na posição base
	position.y = initial_y + movement
