class_name Player extends CharacterBody2D
# The class for the player. Snaps(?) to the nearest rail.

var snapped_to:Rail 

func _physics_process(delta: float) -> void:
	
	
	if snapped_to:
		rotation = lerp(rotation, snapped_to.rotation, 0.7)
		
		velocity = snapped_to.velocity
		
	else:
		#velocity += get_gravity() * delta
		rotation += 0.2
		
		velocity += get_gravity() * delta
		velocity.x /= 1.1
	
	move_and_slide()
