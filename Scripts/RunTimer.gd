class_name RunTimer extends Label
# Tracks how long the player has been in a level, and displays it.

# Time in seconds
var time := 0.0
var paused = false

var deaths := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_level.connect(_on_reset)
	Global.run_timer = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	text = Global.time_as_display(time)



# Reset the timer when the player dies.
func _on_reset() -> void: 
	time = 0
	deaths += 1

# NOTE: NOT HOOKED UP.
func _on_level_selected() -> void:
	deaths = 0
