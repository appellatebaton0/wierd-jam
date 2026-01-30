@tool
class_name Rail extends CharacterBody2D

const TRANSFORM = preload("res://Scenes/Transform.tscn")

@onready var player:Player = get_tree().get_first_node_in_group("Player")

@export var facing_right = true

@export var debug_texture:Texture2D ## The texture to apply to the Transforms in the debug view.

@onready var rail_snap := get_rail_snap()
func get_rail_snap() -> Area2D:
	for child in get_children():
		if child is Area2D: return child
	return null

@warning_ignore("unused_private_class_variable") @export_tool_button("New Transform") 
var _new_transform := _add_transform
@warning_ignore("unused_private_class_variable") @export_tool_button("Clear Transforms") 
var _rem_transforms := _clear_transforms

## All the Transforms this rail will interpolate between.
@export var points:Array[Transform]

var curr:Transform  # The transform to lerp to currently
var next:Transform  # The transform to lerp to next

@export var wait = 0.0 # How long to wait before the next interpolation.
var lerp_amnt = 0.0 # How close this rail is to curr. 0.0 - 1.0

func _ready() -> void:
	# Set up the points.
	points.clear()
	
	for child in get_children(): if child is Transform: points.append(child)
	
	if len(points) > 1:
		curr = points[0]
		next = points[1]
		
		global_position = curr.pos

func _physics_process(delta: float) -> void:
	
	# IF anything's gone wrong or this just shouldn't be done, then don't do it.
	if Engine.is_editor_hint(): return
	
	wait = move_toward(wait, 0, delta)
	if wait: 
		lerp_amnt = 0.0
		velocity = Vector2.ZERO
		print(self, wait)
	if len(points) > 1 and wait == 0.0:
	
		var pos = lerp_ease(curr.pos, next.pos, lerp_amnt, curr.next_ease)
		var rot = lerp_ease(curr.rot, next.rot, lerp_amnt, curr.next_ease)
		
		velocity = (pos - global_position) / delta
		
		rotation = rot
		
		lerp_amnt = move_toward(lerp_amnt, 1.0, delta / curr.next_interpol_time)
		
		if lerp_amnt == 1 and next != curr:
			wait = curr.next_wait
			
			curr = next
			next = points[min(points.find(next) + 1, len(points) - 1)]
			
			lerp_amnt = 0.0
		
	var rail_bodies := rail_snap.get_overlapping_bodies()
	if       rail_bodies.has(player) and player.snapped_to == null:
			 
		player.snapped_to = self
	elif not rail_bodies.has(player) and player.snapped_to == self:
		player.snapped_to = null
	
	if velocity.x: facing_right = velocity.x > 0
	
	move_and_slide()

## Lerp, but the amount is eased.
func lerp_ease(a:Variant, b:Variant, l:float, e:float) -> Variant:
	return lerp(a, b, ease(l, e))

## Tool Functions.

func _clear_transforms(): 
	for child in get_children(): if child is Transform: child.queue_free()
	points.clear()

func _add_transform():
	# Make and setup the transform.
	var new:Transform = TRANSFORM.instantiate()
	
	new.setup(self)
	new.name = "Point " + str(len(points))
	
	points.append(new)
	
	# Fix the rotation.
	
	rotation = 0.0

var last:Vector2
func _process(_delta: float) -> void: if Engine.is_editor_hint():
	if last != position:
		last = position
		queue_redraw()
