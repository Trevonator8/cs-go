extends Control

@onready var PauseMenu = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Back.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_options_pressed() -> void:
	var optionsScn = $Options2
	optionsScn.visible = !optionsScn.visible
	var MenuStuff = $VBoxContainer
	MenuStuff.visible = !MenuStuff.visible


func _on_back_pressed() -> void:
	PauseMenu.visible = !PauseMenu.visible
	Engine.time_scale = 1


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
