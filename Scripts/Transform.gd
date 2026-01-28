@tool
class_name Transform extends Resource

@export var pos:Vector2
@export var rot:float

@export var next_interpol_time := 1.0

func _debug_draw(with:Rail, interpolation:float):
	var real_pos := pos - with.global_position
	
	var color = lerp(Color(1,0,0), Color(0,1,0), interpolation)
	
	with.draw_texture(with.debug_texture, real_pos - with.debug_texture.get_size() / 2, Color(1,1,1, 0.3))
	with.draw_line(real_pos, real_pos + Vector2(0,-20).rotated(rot), color, 2)
	#with.draw_circle(real_pos, 10.0, color)
