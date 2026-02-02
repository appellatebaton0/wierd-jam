class_name RunTimer extends Label
# Tracks how long the player has been in a level, and displays it.

# Time in seconds
var time := 0.0
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset_level.connect(_on_reset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	text = time_as_display()

# Returns the time formatted as xx:xx.xx
func time_as_display() -> String:
	var t:float = floor(time * 100) / 100
	
	# Get the num of milliseconds, seconds, and minutes.
	var mili:int = (t - floor(t)) * 100
	var seco:int = int(t - (mili / 100.0)) % 60
	var minu:int = floor((t - seco) / 60)
	
	return digi(minu) + ":" + digi(seco) + "." + digi(mili)

# Returns the num as a string, in 00 format regardless of value (below 100)
func digi(num:int) -> String: return ("0" if num < 10 else "") + str(num)

# Reset the timer when the player dies.
func _on_reset() -> void: time = 0
