@tool
class_name DeathBorder extends Node2D

@export var LINE_COLOR := Color(0.802, 0.078, 0.086, 1.0)
@export var LINE_WIDTH := 20.0

@export var MAIN_LENGTH := 1000
@export var TYPE_LENGTH := 100

enum ORI {VERTICAL, HORIZONTAL}
@export var orientation := ORI.HORIZONTAL : set = set_ori
func set_ori(to:ORI):
	orientation = to
	queue_redraw()

enum TYPE {MORE, LESS}
@export var type := TYPE.MORE : set = set_type
func set_type(to:TYPE):
	type = to
	queue_redraw()

@onready var player:Player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _draw() -> void: if Engine.is_editor_hint():
	match orientation:
		ORI.VERTICAL:   
			draw_line(Vector2(0, -MAIN_LENGTH), Vector2(0, MAIN_LENGTH), LINE_COLOR, LINE_WIDTH)
			match type:
				TYPE.MORE: draw_line(Vector2(0, 0), Vector2( TYPE_LENGTH, 0), LINE_COLOR, LINE_WIDTH)
				TYPE.LESS: draw_line(Vector2(0, 0), Vector2(-TYPE_LENGTH, 0), LINE_COLOR, LINE_WIDTH)
		ORI.HORIZONTAL: 
			draw_line(Vector2(-MAIN_LENGTH, 0), Vector2(MAIN_LENGTH, 0), LINE_COLOR, LINE_WIDTH)
			match type:
				TYPE.MORE: draw_line(Vector2(0, 0), Vector2(0,  TYPE_LENGTH), LINE_COLOR, LINE_WIDTH)
				TYPE.LESS: draw_line(Vector2(0, 0), Vector2(0, -TYPE_LENGTH), LINE_COLOR, LINE_WIDTH)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: if not Engine.is_editor_hint():
	if is_met(): Global.reset_level.emit()

func is_met() -> bool:
	match orientation:
		ORI.VERTICAL:   return check(player.global_position.x, global_position.x)
		ORI.HORIZONTAL: return check(player.global_position.y, global_position.y)
	return false

func check(a:float, b:float) -> bool:
	match type:
		TYPE.MORE: return a > b
		TYPE.LESS: return a < b
	return false
