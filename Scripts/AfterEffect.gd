class_name AfterEffect extends Polygon2D
# Acts like a particle for the rails.

var in_use := false

@export 
var fade_time := 0.5
var fade_timer := -1.0

func _process(delta: float) -> void:
	if fade_timer > 0:
		fade_timer = move_toward(fade_timer, 0, delta)
		
		modulate.a = fade_timer / fade_time
	elif fade_timer == 0: 
		in_use = false
		fade_timer = -1

func use(by:Rail):
	polygon = by.poly.polygon
	color = by.color() * 1.7
	
	in_use = true
	fade_timer = fade_time
	global_position = by.global_position
	global_rotation = by.global_rotation
