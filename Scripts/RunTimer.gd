class_name RunTimer extends Label
# Tracks how long the player has been in a level, and displays it.

@onready var animator:Animator = get_tree().get_first_node_in_group("Animator")

# Time in seconds
var time := 0.0
var paused = false

var deaths := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_level.connect(_on_reset)
	Global.loaded_level.connect(_on_level_loaded)
	Global.run_timer = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not animator.current_animation == "Game -> Level": time += delta
	
	text = Global.time_as_display(time)

# Reset the timer when the player dies.
func _on_reset() -> void: 
	if animator.is_playing(): return
	
	time = 0
	deaths += 1

func _on_level_loaded() -> void:
	time = 0
	deaths = 0
