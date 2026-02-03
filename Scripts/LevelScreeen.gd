class_name LevelScreen extends Panel
## Controls the level screen of the menu.

const LEVEL_PATH := "res://Scenes/Levels/"
const LEVEL_ENTRY_SCENE   := preload("res://Scenes/LevelEntry.tscn")
const ATTEMPT_ENTRY_SCENE := preload("res://Scenes/AttemptEntry.tscn")

## Stores the level entries.
@onready var level_entry_box := %LevelEntryBox

## All the controls on the right side infobox.
@onready var level_title_lab := %LevelTitle
@onready var attempts_lab    := %Attempts
@onready var best_time_lab   := %BestTime
@onready var attempt_box     := %AttemptBox

@onready var animator:Animator = get_tree().get_first_node_in_group("Animator")

var level_data:Array[LevelData]
var selected_level:LevelData

func _ready() -> void: 
	load_levels()
		

## Loads all the levels into LevelData, and makes entries for each of them.
func load_levels() -> void:
	var dir = DirAccess.open(LEVEL_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				file_name.replace(".remap", "") # NO.
		
				var data = create_data_from(LEVEL_PATH + file_name)
				create_entry_from(data)
			file_name = dir.get_next()
	else: print("An error occurred when trying to access the path.")

func create_data_from(path:StringName) -> LevelData:
	var new = LevelData.new()
	
	new.scene = load(path)
	new.level_name = path.replace(LEVEL_PATH, "").replace(".tscn", "").right(-1)
	
	level_data.append(new)
	
	return new

func create_entry_from(data:LevelData) -> void:
	var new:LevelEntry = LEVEL_ENTRY_SCENE.instantiate()
	
	level_entry_box.add_child(new)
	
	new.setup(data)
	
	new.pressed.connect(_on_level_selected.bind(data))

func create_attempt_from(data:LevelData, index:int) -> void:
	var attempt = data.attempts[index]
	
	var new:Label = ATTEMPT_ENTRY_SCENE.instantiate()
	
	attempt_box.add_child(new)
	
	new.text = "ATTEMPT %s | TIME %s | DEATHS %s" % [index, Global.time_as_display(attempt.time), Global.digi(attempt.deaths)]

func _on_level_selected(data:LevelData) -> void:
	
	for entry in level_entry_box.get_children(): if entry is LevelEntry: if entry.data != data: entry._other_selected()
	
	level_title_lab.text = data.level_name
	attempts_lab.text = "ATTEMPTS: " + str(len(data.attempts))
	
	var best_time := 0
	for attempt in data.attempts:
		if attempt.time < best_time or best_time == 0:
			best_time = attempt.time
	
	best_time_lab.text = "BEST TIME: " + Global.time_as_display(best_time)
	
	# Clear existing attempt entries and add in the real ones.
	for child in attempt_box.get_children(): child.queue_free()
	for i in range(len(data.attempts)): create_attempt_from(data, i) 
	
	selected_level = data

func _on_play_pressed() -> void:
	if not selected_level: return
	
	# Load up the currently selected level
	animator._start_level(selected_level)
