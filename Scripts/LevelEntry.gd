class_name LevelEntry extends Button

var data:LevelData

func setup(with:LevelData):
	data = with
	
	# Set some labels somewhere using the data.
	text = with.level_name

func _other_selected(): disabled = false
func  _this_selected(): disabled = true
