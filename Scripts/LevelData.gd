class_name LevelData extends Resource
## Stores all the high-level data for a level.
## Times, attempts, that stuff.

var scene:PackedScene
var level_name:StringName
var attempts:Array[Attempt]

## Called when a level is beat; stores the data of that attempt.
func store_attempt(): attempts.append(Attempt.new())

class Attempt:
	var time:float
	var deaths:int
	
	func _init() -> void:
		time   = Global.run_timer.time
		deaths = Global.run_timer.deaths
