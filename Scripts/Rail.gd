@tool
@abstract class_name Rail extends CharacterBody2D

@export_storage var start_position:Vector2
@export_storage var start_rotation:float
@export_storage var end_position:Vector2
@export_storage var end_rotation:float

@export_tool_button("Set Start Transform") var set_start := _set_start_pos
@export_tool_button("Set End Transform") var set_end := _set_end_pos

func _set_start_pos():
	start_position = position
	start_rotation = rotation
	
	rotation = 0.0
	
	queue_redraw()
func _set_end_pos():
	end_position = position
	start_rotation = rotation
	
	rotation = 0.0
	
	queue_redraw()

func _draw() -> void: if Engine.is_editor_hint():
	var rsp := start_position - position
	var rep := end_position   - position
	
	draw_line(rsp, rsp + Vector2(0,-20).rotated(start_rotation), Color(0.0, 1.0, 0.0, 1.0))
	draw_circle(rsp, 10.0, Color(0.0, 1.0, 0.0, 1.0))
	
	draw_line(rep, rep + Vector2(0,-20).rotated(end_rotation), Color(0.0, 1.0, 0.0, 1.0))
	draw_circle(rep, 10.0, Color(1.0, 0.0, 0.0, 1.0))
