class_name Goal extends Area2D
# When the player coincides with this, the level is complete.

@onready var animator:Animator = get_tree().get_first_node_in_group("Animator")

func _on_body_entered(body: Node2D) -> void: if body is Player: # It should always be, but make sure.
	
	## Something something level ends.
	
	animator._end_level()
	
	%Touch.emitting = true	
	
	for child in get_parent().get_children(): if child is DeathBorder: child.queue_free()
	pass
