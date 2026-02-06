class_name BackgroundParticles extends GPUParticles2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position
