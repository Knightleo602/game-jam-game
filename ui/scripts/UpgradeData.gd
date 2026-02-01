extends Resource
class_name UpgradeData  # Isso faz ele aparecer na lista de "New Resource"

@export_group("Visual")
@export var icon: Texture2D
@export var title: String
@export_multiline var description: String

@export_group("Atributos")
@export var attribute_name: String = "forca"
@export var value_modifier: float = 10.0
