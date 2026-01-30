class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

const JUMP_BUFFER := 0.1
const COYOTE_TIME := 0.1

var jump_buffering := 0.0
var coyote_timer   := 0.0
var last_rotation  := 0.0
var snap_buffer = 0.0

var snapped_to:Rail 

var jump_velo := 0.0

func _physics_process(delta: float) -> void:
	
	look_at(global_position + velocity)
	
	jump_buffering = move_toward(jump_buffering, 0, delta)
	coyote_timer = move_toward(coyote_timer, 0, delta)
	snap_buffer = move_toward(snap_buffer, 0, delta)
	
	if Input.is_action_just_pressed("Jump"): jump_buffering = JUMP_BUFFER
	
	if jump_buffering and coyote_timer:
		
		velocity = Vector2(400 * (1 if velocity.y < 0 else -1), -400).rotated(rotation)
		snap_buffer = 0.2
		
		print("!!")
		
		jump_buffering = 0.0
		coyote_timer = 0.0
	
	$Label.text = str(velocity.x >= 0.0) + " | " + str(floor(rad_to_deg(rotation))) + " | " + str(velocity)
	if snapped_to:
		coyote_timer = COYOTE_TIME
		## Match the rotation
		#rotation = lerp(rotation, snapped_to.rotation, 0.7)
		#last_rotation = rotation
		
		if not snap_buffer:
			# Match the velocity / grind on the rail
			var grind_vel = Vector2(450, 0).rotated(snapped_to.rotation)
			
			if mag(grind_vel) > mag(velocity):
				velocity = grind_vel
			
		
		jump_velo /= 1.02
	else:
		rotation += 0.2
		
		jump_velo = 0.0
		
		
		velocity += get_gravity() * delta #* 0.6
	
	move_and_slide()

## The magnitude of a vector2
func mag(a:Vector2) -> float: return sqrt(pow(a.x,2) + pow(a.y, 2))
