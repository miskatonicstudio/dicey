extends RigidBody


var normals = []

func _ready():
	var faces = $Model.mesh.get_faces()
	
	var side = 0
	for i in range(0, len(faces), 3):
		var v1 = faces[i] - faces[i+1]
		var v2 = faces[i+1] - faces[i+2]
		var normal = v1.normalized().cross(v2.normalized())
		normal = normal.normalized()
		
		var found = false
		
		for n in normals:
			if normal.dot(n) >= 0.98:
				found = true
				break
		if found:
			continue
		
		normals.append(normal)
		
		var side_scene = load("res://scenes/Side.tscn").instance()
		side_scene.value = side + 1
		add_child(side_scene)
		var target = to_global(normal * 100) + to_global(Vector3.ZERO)
		side_scene.look_at(target, Vector3.UP)
		side_scene.rotation_degrees.x -= 90
		side_scene.translate_object_local(Vector3(0, 0.2, 0))
		side += 1
