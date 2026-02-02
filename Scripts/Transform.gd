@tool
class_name Transform extends Polygon2D

@export var next_interpol_time := 1.2
@export var next_ease := -2.0
@export var next_wait := 0.0

@export var pos:Vector2
@export var rot:float

const DEBUG = false #true

func _ready() -> void: 
	visible = Engine.is_editor_hint() or DEBUG
	if not Engine.is_editor_hint():
		pos = global_position
		rot = global_rotation

func setup(with:Rail):
	with.add_child(self)
	
	pos = with.global_position
	rot = with.rotation
	
	polygon = with.poly.polygon
	color = with.color()
	
	owner = with.owner

func _process(_delta: float) -> void:
	if not visible: return
	global_position = pos if pos else global_position
	global_rotation = rot if rot else global_rotation
