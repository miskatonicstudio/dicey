extends Spatial

const DICE = {
	"d6": preload("res://scenes/dice/D6.tscn"),
	"d20": preload("res://scenes/dice/D20.tscn"),
}

onready var label = $CenterContainer/Label
onready var panel = $CenterContainer/Panel
onready var panel_animation_player = $CenterContainer/Panel/AnimationPlayer
onready var table = $Table

var requested_dice = []
var rolled_values = []


func _ready():
	randomize()
	_initialize_dice_controls()
	refresh_dice_counts()


func _initialize_dice_controls():
	for dice_control in get_tree().get_nodes_in_group("dice_control"):
		var dice_type = dice_control.name.to_lower()
		var button = dice_control.get_node("Button")
		button.connect("pressed", self, "add_dice", [dice_type])


func add_dice(dice_type):
	requested_dice.append(dice_type)
	refresh_dice_counts()


func refresh_dice_counts():
	for dice_control in get_tree().get_nodes_in_group("dice_control"):
		var dice_type = dice_control.name.to_lower()
		var count_label = dice_control.get_node("Count")
		count_label.text = str(requested_dice.count(dice_type))


func _on_rolled(value):
	label.text += str(value) + "  "
	if len(label.text.split(" ", false)) == len(get_tree().get_nodes_in_group("dice")):
		label.text += "\n(click to roll again)"
		panel.show()


func roll():
	label.text = " "
	
	# Remove old dice
	for die in get_tree().get_nodes_in_group("dice"):
		die.free()
	
	var index = 0
	
	for die_str in requested_dice:
		var die = DICE[die_str].instance()
		table.add_child(die)
		die.translation = Vector3(index, 2, 0)
		index += 1
		die.apply_torque_impulse(Vector3(
			max(0.3, randf()), max(0.3, randf()), max(0.3, randf())
		))
		die.apply_central_impulse(8 * Vector3(
			2.0 * (randf() - 0.5), -abs(randf()), 2.0 * (randf() - 0.5)
		))
	
	for side in get_tree().get_nodes_in_group("sides"):
		side.connect("rolled", self, "_on_rolled")


func _on_Roll_pressed():
	if not requested_dice:
		panel_animation_player.play("show_warning")
	else:
		panel.hide()
		roll()


func _on_Clear_pressed():
	requested_dice = []
	refresh_dice_counts()
