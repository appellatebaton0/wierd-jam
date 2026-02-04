@tool
class_name AnimationOverlay extends Control

# A float displaying the amount of progress in h
@export var progress := 0.0 : set = set_progress
func set_progress(to:float): progress = clamp(to, 0.0, 1.0)

var rects:Array[ColorRect]
var rect_seeds:Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in get_children(): if child is ColorRect: 
		rects.append(child)
		rect_seeds.append(randf_range(-3, -1.25))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in range(len(rects)):
		rects[i].position.x = (ease(progress, rect_seeds[i]) - 0.63) * 3500
