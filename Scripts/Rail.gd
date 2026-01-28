@tool
@abstract class_name Rail extends CharacterBody2D

@export var easing := 0.4

@export var debug_texture:Texture2D

@warning_ignore("unused_private_class_variable")
@export_tool_button("New Transform") var _new_transform := _add_transform
@warning_ignore("unused_private_class_variable")
@export_tool_button("Clear Transforms") var _rem_transforms := _clear_transforms


## Lerp from one transform to another.
@warning_ignore("shadowed_variable")
func interpolate(from:Transform, to:Transform, lerp_amnt:float, ease_amnt := 1.0) -> Transform:
	
	var pos = lerp(from.pos, to.pos, ease(lerp_amnt, ease_amnt))
	var rot = lerp(from.rot, to.rot, ease(lerp_amnt, ease_amnt))
	
	var new = Transform.new()
	new.pos = pos
	new.rot = rot
	
	return new

@export var points:Array[Transform]
var current := 0
var next := 1
var lerp_amnt = 0.0

var form:Transform
func _physics_process(delta: float) -> void:
	
	if Engine.is_editor_hint() or not len(points): return
	
	
	var a = points[current]
	var b = points[next]
	
	form = interpolate(a, b, ease(lerp_amnt, easing))
	
	velocity = (form.pos - global_position) / delta
	
	rotation = form.rot
	
	lerp_amnt = move_toward(lerp_amnt, 1.0, delta / points[current].next_interpol_time)
	
	if lerp_amnt == 1 and next != current:
		current = next
		next = min(next + 1, len(points) - 1)
		lerp_amnt = 0.0
		
	
	move_and_slide()
	
	pass

func mag(a:Vector2, b:Vector2) -> Vector2:
	return (b - a) / a.direction_to(b)

## Tool Functionality.


func _clear_transforms(): 
	var unre := EditorInterface.get_editor_undo_redo()
	
	unre.create_action("Clear Rail Points")
	points.clear()
	unre.add_do_method(self, "queue_redraw")
	
	unre.commit_action()
	#points.clear()
	
	#queue_redraw()

func _add_transform():
	var unre := EditorInterface.get_editor_undo_redo()
	
	unre.create_action("Make Rail Point")
	unre.add_do_method(self, "queue_redraw")
	
	var new = Transform.new()
	new.pos = global_position
	new.rot = rotation
	
	points.append(new)
	
	unre.add_do_property(self, "rotation", 0.0)
	
	unre.commit_action()

func _draw() -> void: #if Engine.is_editor_hint():
	
	var length = len(points)
	for i in range(length):
		var point = points[i]
		var interpol = float(i) / float(length)
		
		point._debug_draw(self, interpol)
	
	if form: form._debug_draw(self, 1.0)

var last:Vector2
func _process(_delta: float) -> void: if Engine.is_editor_hint():
	if last != position:
		last = position
		queue_redraw()
