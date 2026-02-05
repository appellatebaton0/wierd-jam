class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

const DEBUG := false

@onready var spawn_position = global_position

@export var grind_speed := 700.0
@export var jump_height := 670.0

const JUMP_BUFFER := 0.1
var jump_buffering := 0.0

var snapped_to:Rail
var on_snap_mag:float

# A normalized vector of the direction the player is grinding in.
var direction:Vector2 : set =_set_dir
func _set_dir(to:Vector2): direction = to.normalized()

func _ready(): Global.reset_level.connect(_on_reset)

func _physics_process(delta: float) -> void:
	# For the line debugging.
	if DEBUG: queue_redraw()
	
	# Buffer the jump input.
	jump_buffering = move_toward(jump_buffering, 0, delta)
	if Input.is_action_just_pressed("Jump"): jump_buffering = JUMP_BUFFER
	
	velocity += get_gravity() * delta
	
	# Grinding
	if snapped_to:
		velocity = direction * max(grind_speed, on_snap_mag)
		
		if jump_buffering: # Jump
			
			# Get the two options for jump directions. (Perpendiculars to current dir).
			var a = direction.rotated(deg_to_rad(90))
			var b = direction.rotated(deg_to_rad(-90))
			
			# Compare them to the direction from the rail to the player.
			var rail_to_player = snapped_to.global_position.direction_to(global_position)
			
			# Choose the jump direction based on which is closer to that direction.
			var jump_direction = closest([a,b], rail_to_player)
			
			velocity += jump_direction * mag(velocity)
			
			jump_buffering = 0.0
			
			snapped_to = null
	
	# Freefall
	else:
		
		
		# Set the current direction to the velocity (automatically normalized).
		direction = velocity
	
	if not DEBUG: rotation += deg_to_rad(sqrt(pow(velocity.x,2) + pow(velocity.y, 2)) / 40)
	
	move_and_slide()

func _on_rail_enter(rail:Node2D): 
	if   rail is DeathRail: Global.reset_level.emit() # Die.
	elif rail is Rail: snap_to(rail) # Snap to this rail.
func _on_rail_exit (rail:Node2D): if snapped_to == rail: snapped_to = null

func snap_to(rail:Rail):
	snapped_to = rail
	
	
	# Create a vector rotated to mimic the rail's rotation.
	var rail_vector = Vector2.DOWN.rotated(rail.rotation)
	
	# Find the two vectors parallel to the rail.
	var a = rail_vector.rotated(deg_to_rad(-90))
	var b = rail_vector.rotated(deg_to_rad(90))
	
	# Figure out which direction is closer to the current direction, and set to that.
	direction = closest([a,b], direction)
	
	on_snap_mag = mag(velocity.project(direction))

# Returns the Vector2 that is most similar to the comparator out of the given array.
func closest(of:Array[Vector2], compared_to:Vector2):
	var best:Vector2
	var best_dot:float
	
	for vec2 in of:
		var vec_dot := vec2.dot(compared_to)
		
		# IF the best doesn't exist, or this is better than that.
		if not best or vec_dot > best_dot:
			best = vec2
			best_dot = vec_dot
			continue
	
	return best

func _on_reset() -> void:
	velocity = Vector2.ZERO
	global_position = spawn_position
	snapped_to = null

func mag(of:Vector2): return sqrt(pow(of.x, 2) + pow(of.y, 2))

## DEBUG DATA
func _draw() -> void: 
	if not DEBUG: return
	# Debug lines to show the direction and plane parallel. NOTE: Doesn't show correctly with rotation.
	draw_line(Vector2.ZERO, -direction * 250, Color.RED, 15) 
	
	if snapped_to:
		# Get the two options for jump directions. (Perpendiculars to current dir).
		var a = direction.rotated(deg_to_rad(90))
		var b = direction.rotated(deg_to_rad(-90))
		
		# Compare them to the direction from the rail to the player.
		var rail_to_player = snapped_to.global_position.direction_to(global_position)
		
		var jump_direction = a if a.dot(rail_to_player) > b.dot(rail_to_player) else b
		 
		draw_line(Vector2.ZERO, -jump_direction * jump_height, Color.BLUE, 15)
		
		draw_line(to_local(snapped_to.global_position), (Vector2.DOWN.rotated(snapped_to.rotation) * 250) + to_local(snapped_to.global_position), Color.GREEN, 15)
