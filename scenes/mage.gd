extends Node3D

@onready var mm_instance : MultiMeshInstance3D = $MultiMeshInstance
@onready var rows : Node = $Rows
@onready var camera: Camera3D = $Camera

var timer: float
var look: Vector3 = Vector3(0,12,0)

const MAX_COLUMNS = 20

func _ready():
	var mm_rows = rows.get_child_count()
	var mm_columns = MAX_COLUMNS
	var mm_count = mm_rows * mm_columns
	
	mm_instance.multimesh.instance_count = 0 # has to be zero to make changes to multimesh
	mm_instance.multimesh.use_custom_data = true
	mm_instance.multimesh.instance_count = mm_count
	
	var mm_index = 0
	
	for row in rows.get_children():
		randomize()
		var row_global_transform = row.global_transform
		for _column in range(mm_columns):
			mm_instance.multimesh.set_instance_transform(mm_index, row_global_transform)
			row_global_transform.origin.x += 2.0
			var animation_offset = randf_range(0,0.25)

			# you can use this float for your needs in your shader (like alpha control)
			var unused_float = randf_range(0,1)
			
			# randomize animation track either 0 or 1 > current images encode only 2 tracks
			var track = randi_range(0,3)
			if track < 3: track = 0 # 75% cheering, 25% cursing you!
			
			# set custom data
			var custom_data = Color(unused_float, track as float, 1.0, animation_offset)
			mm_instance.multimesh.set_instance_custom_data(mm_index, custom_data)
			mm_instance.multimesh.set_instance_color(mm_index, Color(randf(), randf(), randf(), 1.0))
			mm_index += 1

func _process(delta: float) -> void:
	timer += delta
	camera.position.x = 4 * sin(timer * 0.25)
	camera.position.y = 12 + 5 * sin(timer * 0.125)
	camera.position.z = 15 + 3 * sin(timer * 0.125)
	camera.look_at(look)

	
	
	
