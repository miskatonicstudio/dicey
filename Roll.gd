extends Spatial


func _ready():
	randomize()
	
	for side in get_tree().get_nodes_in_group("sides"):
		side.connect("rolled", self, "_on_rolled")
	
	roll()


func _on_rolled(value):
	$Label.text += str(value) + "  "
	if len($Label.text.split(" ", false)) == len(get_tree().get_nodes_in_group("dice")):
		$Label.text += "\n(click to roll again)"


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		roll()


func roll():
	$Label.text = " "
		
	for side in get_tree().get_nodes_in_group("sides"):
		side.aligned = false
	
	var index = 0
	
	for die in get_tree().get_nodes_in_group("dice"):
		die.translation = Vector3(index, 5, 0)
		index += 1
		die.apply_torque_impulse(Vector3(
			max(0.3, randf()), max(0.3, randf()), max(0.3, randf())
		))
		die.apply_central_impulse(8 * Vector3(
			2.0 * (randf() - 0.5), -abs(randf()), 2.0 * (randf() - 0.5)
		))
