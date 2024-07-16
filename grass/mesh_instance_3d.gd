extends MeshInstance3D

@export var size:int
@export var t:Texture2D

func _ready() -> void:
	mesh.size = Vector2(size,size)
	$MultiMeshInstance3D.material_override.set("shader_parameter/size",size)
