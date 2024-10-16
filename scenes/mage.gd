extends Node3D

const MAX_COLUMNS = 20

@onready var mm_instance = $MultiMeshInstance
@onready var rows = $Rows

func _ready():
	var mm_rows = rows.get_child_count()
	var mm_columns = MAX_COLUMNS
	var mm_count = mm_rows * mm_columns
	
	mm_instance.multimesh.instance_count = 0 #has to be zero to make changes to multimesh
	mm_instance.multimesh.use_custom_data = true
	mm_instance.multimesh.instance_count = mm_count
	
	var mm_index = 0
	
	for row in rows.get_children():
		
		var row_global_transform = row.global_transform
		
		for _column in range(mm_columns):
			mm_instance.multimesh.set_instance_transform(mm_index, row_global_transform)
			row_global_transform.origin.x += 2.0

			var animation_offset = randf()
			
			var rand_col = Color(1.0,1.0,1.0,animation_offset)
			mm_instance.multimesh.set_instance_custom_data(mm_index, rand_col)
			mm_index += 1
