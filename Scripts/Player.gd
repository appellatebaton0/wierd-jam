class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

@export var grind_speed := 500

var snapped_to:Rail
var snap_queue:Array[Rail]

var direction:Vector2 : set =_set_dir

func _set_dir(to:Vector2): direction = to.normalized()

func _ready():
	direction = Vector2.DOWN#.slide()

func _physics_process(delta: float) -> void:
	
	if snapped_to: velocity = direction * grind_speed
	else:
		velocity += get_gravity() * delta
	
	move_and_slide()
	pass

#func _process(delta: float) -> void:
	#if not snap_queue.has(snapped_to): snapped_to = null
	#if not snap_queue.is_empty() and not snapped_to:
		#snap_to(snap_queue[0])

func _on_rail_enter(rail:Node2D): if rail is Rail: snap_to(rail)
func _on_rail_exit (rail:Node2D): if rail is Rail: if snapped_to == rail: snapped_to = null

func snap_to(rail:Rail):
	print("snapped to ", rail)
	snapped_to = rail
	
	# Create a vector rotated to mimic the rail's rotation.
	var rail_vector = Vector2.ONE.rotated(rail.rotation)
	
	# Find the two vectors parallel to the rail.
	var a = rail_vector.rotated(deg_to_rad(-90))
	var b = rail_vector.rotated(deg_to_rad(90))
	
	# Figure out which direction is closer to the current direction, and set to that.
	var a_dot = a.dot(direction)
	var b_dot = b.dot(direction)
	
	direction = a if a_dot > b_dot else b
