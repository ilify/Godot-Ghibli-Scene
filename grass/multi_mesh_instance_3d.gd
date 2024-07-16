extends MultiMeshInstance3D

@export var density:int

func _ready() -> void:
	var size = $"..".size
	multimesh.instance_count = 50 * 50 * density
	for i in range(multimesh.instance_count):
		var Scale = 2
		var ScaleVector = Vector3(Scale,1,Scale)
		var pos = Vector3(randf_range(-size*.5,size*.5),0,randf_range(-size*.5,size*.5))#
		var transfrom = Transform3D(Basis().scaled(ScaleVector),pos).rotated_local(Vector3.UP,randf_range(0.0,360.0))
		multimesh.set_instance_transform(i,transfrom)
