extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Fight.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slap_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/slap.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	var optionsScn = $Options2
	optionsScn.visible = !optionsScn.visible
	var MenuStuff = $VBoxContainer
	MenuStuff.visible = !MenuStuff.visible
	var TitleLabel = $Title
	TitleLabel.visible = !TitleLabel.visible


func _on_fight_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fight.tscn")
	pass # Replace with function body.
