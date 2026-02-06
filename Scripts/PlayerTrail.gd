class_name PlayerTrail extends Line2D
# Handles making a trail to follow after the player

@onready var player:Player = get_tree().get_first_node_in_group("Player")

@export var count       := 5
@export var lerp_amount := 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_level.connect(_on_reset)
	_on_reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	for i in range(len(points)):
		if i == 0:
			set_point_position(i, lerp(get_point_position(i), p(), 1.0))
		else:
			set_point_position(i, lerp(get_point_position(i), get_point_position(i - 1), lerp_amount))

func _on_reset():
	clear_points()
	for i in range(count):
		add_point(p())
	
func p() -> Vector2: return to_local(player.global_position)
