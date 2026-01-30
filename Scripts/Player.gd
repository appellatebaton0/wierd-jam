class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

@export var grind_speed := 700.0
@export var jump_height := 700.0

const JUMP_BUFFER := 0.1
var jump_buffering := 0.0

const SNAP_BUFFER := 0.1
var snap_buffering := 0.0

var snapped_to:Rail

# A normalized vector of the direction the player is grinding in.
var direction:Vector2 : set =_set_dir
func _set_dir(to:Vector2): direction = to.normalized()

func _physics_process(delta: float) -> void:
	# For the line debugging.
	queue_redraw()
	
	jump_buffering = move_toward(jump_buffering, 0, delta)
	if Input.is_action_just_pressed("Jump"): jump_buffering = JUMP_BUFFER
	
	snap_buffering = move_toward(snap_buffering, 0, delta)
	
	# Grinding
	if snapped_to and not snap_buffering: 
		velocity = direction * grind_speed
		
		if jump_buffering: # Jump
			
			print("YUMP")
			
			velocity += Vector2(0, jump_height).rotated(direction.angle())
			
			snap_buffering = SNAP_BUFFER
			
			jump_buffering = 0.0
	
	# Freefall
	else: 
		#rotation += 0.1
		
		velocity += get_gravity() * delta
		
		# Set the current direction to the velocity (automatically normalized).
		direction = velocity
	
	move_and_slide()

func _on_rail_enter(rail:Node2D): if rail is Rail: snap_to(rail)
func _on_rail_exit (rail:Node2D): if rail is Rail: if snapped_to == rail: snapped_to = null

func snap_to(rail:Rail):
	snapped_to = rail
	
	# Create a vector rotated to mimic the rail's rotation.
	var rail_vector = Vector2.DOWN.rotated(rail.rotation)
	
	# Find the two vectors parallel to the rail.
	var a = rail_vector.rotated(deg_to_rad(-90))
	var b = rail_vector.rotated(deg_to_rad(90))
	
	# Figure out which direction is closer to the current direction, and set to that.
	var a_dot = a.dot(direction)
	var b_dot = b.dot(direction)
	
	direction = a if a_dot > b_dot else b

## DEBUG
func _draw() -> void:
	# Debug lines to show the direction and plane parallel. NOTE: Doesn't show correctly with rotation.
	draw_line(Vector2.ZERO, -direction * 250, Color.RED, 15)
	draw_line(Vector2.ZERO, Vector2(0, -jump_height).rotated(direction.angle()), Color.BLUE, 15)
	
	if snapped_to:
		draw_line(to_local(snapped_to.global_position), (Vector2.DOWN.rotated(snapped_to.rotation) * 250) + to_local(snapped_to.global_position), Color.GREEN, 15)
