class_name Camera extends Camera2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.reset_level.connect(_on_reset)
	_on_reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = lerp(global_position, player.global_position + (0.3 * player.velocity), 0.09)

func _on_reset():
	print("R")
	global_position = player.global_position
