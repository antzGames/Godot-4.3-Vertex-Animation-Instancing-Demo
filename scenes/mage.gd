extends Node3D

const MAX_COLUMNS = 20

@onready var mm_instance = $MultiMeshInstance
@onready var rows = $Rows

@onready var camera: Camera3D = $Camera
var timer: float
var look: Vector3 = Vector3(0,12,0)

func _ready():
	var mm_rows = rows.get_child_count()
	var mm_columns = MAX_COLUMNS
	var mm_count = mm_rows * mm_columns
	
	mm_instance.multimesh.instance_count = 0 #has to be zero to make changes to multimesh
	mm_instance.multimesh.use_custom_data = true
	mm_instance.multimesh.instance_count = mm_count
	
	var mm_index = 0
	
	for row in rows.get_children():
		randomize()
		var row_global_transform = row.global_transform
		for _column in range(mm_columns):
			mm_instance.multimesh.set_instance_transform(mm_index, row_global_transform)
			row_global_transform.origin.x += 2.0
			var animation_offset = randf_range(0,1)

			# encode a random RGB color.  Note Alpha channel not used in shader
			var tint = getEncodedFloat(Vector4(randf_range(0,1),randf_range(0,1),randf_range(0,1), 1.0))
			
			var track = randi_range(0,3)
			if track < 3: track = 0 # 75% cheering, 25% cursing you!
			
			var rand_col = Color(tint, track as float, 1.0, animation_offset)
			mm_instance.multimesh.set_instance_custom_data(mm_index, rand_col)
			mm_index += 1

func _process(delta: float) -> void:
	timer += delta
	camera.position.x = 4 * sin(timer * 0.25)
	camera.position.y = 12 + 5 * sin(timer * 0.125)
	camera.position.z = 15 + 3 * sin(timer * 0.125)
	camera.look_at(look)

func getEncodedFloat(color: Vector4) -> float:
	return color.dot(Vector4(1.0, 1/255.0, 1/65025.0, 1/16581375.0))
	
	
	
