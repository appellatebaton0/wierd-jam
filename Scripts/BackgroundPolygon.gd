@tool
class_name BackgroundPolygon extends Polygon2D
# A polygon shaped like a box with a spiked top, to give the background some detail.

## The dimensions of the base box.
@export var box_dimensions := Vector2(500, 300)

@export_group("Spike Vertical Range", "spike_range_y_")
@export var spike_range_y_min := 10.0
@export var spike_range_y_max := 50.0

@export_group("Spike Horizontal Range", "spike_range_x_")
@export var spike_range_x_min := 30.0
@export var spike_range_x_max := 50.0

@export_tool_button("Regenerate") var regen_button := regenerate

func regenerate() -> void:
	
	var new_polygon:Array[Vector2]
	
	# Half it to center it.
	var dim = box_dimensions / 2
	
	# Add the box.
	new_polygon.append(Vector2(dim.x, -dim.y))
	new_polygon.append(Vector2(dim.x, dim.y))
	new_polygon.append(Vector2(-dim.x, dim.y))
	new_polygon.append(Vector2(-dim.x, -dim.y))
	
	var x = -dim.x
	var up = true
	while x < dim.x:
		# Add a peak/valley.
		var y = -dim.y + randf_range(spike_range_y_min, spike_range_y_max) * (1 if up else -1)
		
		new_polygon.append(Vector2(x,y))
		
		# Setup for the next.
		x += randf_range(spike_range_x_min, spike_range_x_max)
		up = !up
	
	set_polygon(new_polygon)
	
	pass
