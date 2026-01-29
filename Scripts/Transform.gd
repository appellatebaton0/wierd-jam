@tool
class_name Transform extends Sprite2D

@export var next_interpol_time := 1.0
@export var next_ease := 0.4

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
	
	texture = with.debug_texture
	owner = with.owner

func _process(delta: float) -> void: if visible:
	global_position = pos if pos else global_position
	global_rotation = rot if rot else global_rotation
