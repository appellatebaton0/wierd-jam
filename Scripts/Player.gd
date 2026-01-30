class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

var snapped_to:Rail 

var jump_velo := 0.0

func _physics_process(delta: float) -> void:
	
	if snapped_to:
		# Match the rotation
		rotation = lerp(rotation, snapped_to.rotation, 0.7)
		
		# Match the velocity / grind on the rail
		var grind_vel = Vector2(230 * (1 if snapped_to.facing_right else -1), 0).rotated(rotation)
		var inert_vel = snapped_to.velocity
		
		if mag(grind_vel) > mag(inert_vel):
			velocity = grind_vel
		else: 
			velocity = inert_vel
		
		if Input.is_action_just_pressed("JumpPerp"):
			jump_velo = -500
		
		velocity += Vector2(0, jump_velo).rotated(rotation)
		jump_velo /= 1.1
	else:
		rotation += 0.2
		
		jump_velo = 0.0
		
		velocity.x /= 1.01
		velocity += get_gravity() * delta * 0.6
	
	move_and_slide()

## The magnitude of a vector2
func mag(a:Vector2) -> float: return sqrt(pow(a.x,2) + pow(a.y, 2))
