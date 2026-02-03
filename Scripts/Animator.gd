class_name Animator extends AnimationPlayer
# Manages all the menu transitions, as well as level unloading.

# Where to put levels.
@export var main:Node

var current_level_data:LevelData
var current_level_instance:Node

# Set in animations to activate any sub-part of an animation.
@export var activate:bool : set = _on_activate

var queued_for:StringName = "None."

func _start_level(level:LevelData):
	current_level_data = level
	
	queued_for = "Level Start"
	play("Level -> Game")

func _end_level():
	queued_for = "Level End"
	play("Game -> Level")

func _on_activate(to:bool) -> void: if to:
	match queued_for:
		"Level Start":
			# Load up the currently selected level, and do something about the screens.
			
			var level = current_level_data.scene.instantiate()

			main.add_child(level)
			
			current_level_instance = level
		"Level End":
			current_level_data.store_attempt()
			
			current_level_instance.queue_free()
			current_level_instance = null
	
