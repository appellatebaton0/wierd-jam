class_name Camera extends Camera2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = lerp(global_position, player.global_position + (0.2 * player.velocity), 0.1)
