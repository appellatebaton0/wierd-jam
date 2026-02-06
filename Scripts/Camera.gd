class_name Camera extends Camera2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.reset_level.connect(_on_reset)
	_on_reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = lerp(global_position, player.global_position + (0.3 * player.velocity), 0.09)

	# Zoom in just a little bit when going fast.
	var z = lerp(zoom.x, 0.5 + (abs(player.mag(player.velocity)) / 15000), 0.1)
	zoom = Vector2(z,z)

func _on_reset():
	global_position = player.global_position
