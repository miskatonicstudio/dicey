extends Spatial


signal rolled (value)

export (int) var value

var time_aligned = 0.0
var aligned = false

func _ready():
	$Viewport/Label.text = str(value)
	$MeshInstance.material_override = $MeshInstance.material_override.duplicate()
	$MeshInstance.material_override.albedo_texture = $Viewport.get_texture()


func _process(delta):
	if aligned:
		return
	
	var global_normal = (to_global(Vector3.UP) - to_global(Vector3.ZERO)).normalized()
	if global_normal.dot(Vector3.UP) >= 0.95:
		time_aligned += delta
	else:
		time_aligned = 0.0
	
	if time_aligned >= 2.0 and not aligned:
		aligned = true
		time_aligned = 0.0
		emit_signal("rolled", value)
