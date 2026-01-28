@tool
@abstract class_name Rail extends CharacterBody2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("New Transform") var _new_transform := _add_transform
@warning_ignore("unused_private_class_variable")
@export_tool_button("Clear Transforms") var _rem_transforms := _clear_transforms

class Transform:
	var pos:Vector2
	var rot:float
	
	func _init(set_pos, set_rot) -> void:
		pos = set_pos
		rot = set_rot
	
	func _debug_draw(with:Rail, interpolation:float):
		var real_pos := pos - with.position
		
		var color = lerp(Color(1,0,0), Color(0,1,0), interpolation)
		
		with.draw_line(real_pos, real_pos + Vector2(0,-20).rotated(rot), color, 2)
		with.draw_circle(real_pos, 10.0, color)

## Lerp from one transform to another.
@warning_ignore("shadowed_variable")
func interpolate(from:Transform, to:Transform, lerp_amnt:float, ease_amnt := 1.0) -> Transform:
	
	var pos = lerp(from.pos, to.pos, ease(lerp_amnt, ease_amnt))
	var rot = lerp(from.rot, to.rot, ease(lerp_amnt, ease_amnt))
	
	return Transform.new(pos, rot)

@export_storage var points:Array[Transform]
var current := 0
var next := 1
var lerp_amnt = 0.0

func _ready() -> void:
	print(points)
	pass

func _physics_process(delta: float) -> void:
	
	var a = points[current]
	var b = points[next]
	
	var form = interpolate(a, b, lerp_amnt)
	
	velocity = position.direction_to(form.pos) * delta * 60
	
	lerp_amnt = move_toward(lerp_amnt, 1.0, delta)
	
	move_and_slide()
	
	pass


## Tool Functionality.


func _clear_transforms(): 
	points.clear()
	
	queue_redraw()

func _add_transform():
	points.append(Transform.new(position, rotation))
	
	rotation = 0.0
	
	queue_redraw()

func _draw() -> void: if Engine.is_editor_hint():
	
	var length = len(points)
	for i in range(length):
		var point = points[i]
		var interpol = float(i) / float(length)
		
		point._debug_draw(self, interpol)

var last:Vector2
func _process(_delta: float) -> void: if Engine.is_editor_hint():
	if last != position:
		last = position
		queue_redraw()
